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
#install_tini_docker

# Write os-release
# shellcheck disable=SC2153
printf "%-64s" "rescue_version=${RESCUE_VERSION}" > "${BINARIES_DIR}/version-header.bin"
MAJOR=$((10#${RESCUE_VERSION:0:2}))
MINOR=$((10#${RESCUE_VERSION:2:2}))
PATCH=$((10#${RESCUE_VERSION:4:2}))

READABLE_VERSION="${MAJOR}.${MINOR}.${PATCH}"
(
    echo "NAME=\"${OS_NAME}\""
    echo "VERSION=\"${READABLE_VERSION} (${BOARD_NAME})\""
    echo "ID=${OS_ID}"
    echo "VERSION_ID=${READABLE_VERSION}"
    echo "PRETTY_NAME=\"${OS_NAME} ${READABLE_VERSION}\""
    echo "CPE_NAME=cpe:2.3:o:jethome:${OS_ID}:${READABLE_VERSION}:*:${DEPLOYMENT}:*:*:*:${BOARD_ID}:*"
    echo "HOME_URL=https://jethome.com/"
    echo "VARIANT=\"${OS_NAME} ${BOARD_NAME}\""
    echo "VARIANT_ID=${BOARD_ID}"
) > "${TARGET_DIR}/usr/lib/os-release"
ln -sf ../usr/lib/os-release "${TARGET_DIR}/etc/os-release"

# Write machine-info
(
    echo "CHASSIS=${CHASSIS}"
    echo "DEPLOYMENT=${DEPLOYMENT}"
) > "${TARGET_DIR}/etc/machine-info"


# Setup RAUC
#prepare_rauc_signing
#write_rauc_config
#install_rauc_certs
install_bootloader_config

# Fix overlay presets
#"${HOST_DIR}/bin/systemctl" --root="${TARGET_DIR}" preset-all
