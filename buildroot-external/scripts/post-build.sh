#!/bin/bash
# shellcheck disable=SC1090,SC1091
set -e

SCRIPT_DIR=${BR2_EXTERNAL_JHOS_PATH}/scripts
BOARD_DIR=${2}

. "${BR2_EXTERNAL_JHOS_PATH}/meta"
. "${BOARD_DIR}/meta"

. "${SCRIPT_DIR}/name.sh"
. "${SCRIPT_DIR}/rauc.sh"

#os-release
OS_RELEASE="${TARGET_DIR}/usr/lib/os-release"
if [ -f "${OS_RELEASE}" ]; then
    JRESCUE_NAME="jrescue"
    JRESCUE_VER="1.0"

    sed -i \
        -e "s/^NAME=.*/NAME=${JRESCUE_NAME}/" \
        -e "s/^ID=.*/ID=${JRESCUE_NAME}/" \
        -e "s/^VERSION_ID=.*/VERSION_ID=${JRESCUE_VER}/" \
        -e "s/^PRETTY_NAME=.*/PRETTY_NAME=\"${JRESCUE_NAME} ${JRESCUE_VER}\"/" \
        "${OS_RELEASE}"

    grep -q '^NAME=' "${OS_RELEASE}" || echo "NAME=${JRESCUE_NAME}" >> "${OS_RELEASE}"
    grep -q '^ID=' "${OS_RELEASE}" || echo "ID=${JRESCUE_NAME}" >> "${OS_RELEASE}"
    grep -q '^VERSION_ID=' "${OS_RELEASE}" || echo "VERSION_ID=${JRESCUE_VER}" >> "${OS_RELEASE}"
    grep -q '^PRETTY_NAME=' "${OS_RELEASE}" || echo "PRETTY_NAME=\"${JRESCUE_NAME} ${JRESCUE_VER}\"" >> "${OS_RELEASE}"
fi

# Write machine-info
(
    echo "CHASSIS=${CHASSIS}"
    echo "DEPLOYMENT=${DEPLOYMENT}"
    echo "HARDWARE_VENDOR=\"JetHome\""
    echo "HARDWARE_MODEL=\"${BOARD_NAME}\""
    echo "BOARD_ID=${BOARD_ID}"
) > "${TARGET_DIR}/etc/machine-info"

# Export board identity into login-shell environment
mkdir -p "${TARGET_DIR}/etc/profile.d"
(
    echo "export BOARD=${BOARD_ID}"
    echo "export BOARD_NAME=\"${BOARD_NAME}\""
) > "${TARGET_DIR}/etc/profile.d/board.sh"

install_bootloader_config

if [ "${BOARD_ID}" = "jethub-j100" ] && [ -d "${TARGET_DIR}/lib/modules" ]; then
    echo "Removing kernel modules (module-free recovery initramfs)"
    rm -rf "${TARGET_DIR}/lib/modules"
fi

if [ -z "${KERNEL_DTB}" ]; then
    echo "ERROR: KERNEL_DTB not set in ${BOARD_DIR}/meta"
    exit 1
fi

# Vendor kernel (J310) keeps its DTB under common_drivers in the build tree
# and buildroot never installs it, so a fresh copy there always wins over a
# possibly stale file in BINARIES_DIR left by a previous build.
DTB_SRC="$(find "${BASE_DIR}/build" -path "*/common_drivers/arch/arm64/boot/dts/amlogic/${KERNEL_DTB}" -print -quit)"

if [ -n "${DTB_SRC}" ] && [ -f "${DTB_SRC}" ]; then
    cp "${DTB_SRC}" "${BINARIES_DIR}/"
elif [ -f "${BINARIES_DIR}/${KERNEL_DTB}" ]; then
    # Mainline kernel (J100): linux.mk reinstalls the in-tree DTB into
    # BINARIES_DIR on every kernel install
    echo "Using ${KERNEL_DTB} installed in ${BINARIES_DIR}"
else
    echo "ERROR: ${KERNEL_DTB} not found in ${BINARIES_DIR} or under ${BASE_DIR}/build/"
    exit 1
fi

