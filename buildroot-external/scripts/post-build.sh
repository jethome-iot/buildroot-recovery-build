#!/bin/bash
# shellcheck disable=SC1090,SC1091
set -e

SCRIPT_DIR=${BR2_EXTERNAL_JHOS_PATH}/scripts
BOARD_DIR=${2}

. "${BR2_EXTERNAL_JHOS_PATH}/meta"
. "${BOARD_DIR}/meta"

. "${SCRIPT_DIR}/rootfs-layer.sh"
. "${SCRIPT_DIR}/name.sh"
. "${SCRIPT_DIR}/rauc.sh"

# Source board-specific post-build script if it exists
if [ -f "${BOARD_DIR}/post-build-j200.sh" ]; then
    . "${BOARD_DIR}/post-build-j200.sh"
fi

# JHOS tasks
fix_rootfs

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
) > "${TARGET_DIR}/etc/machine-info"

install_bootloader_config

