#!/bin/bash
# shellcheck disable=SC2155

function os_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    dd if=/dev/zero of="${BINARIES_DIR}/env.blank" bs=64K count=1
    lzma -f -k -9 "${BINARIES_DIR}/Image"

    mkdir -p "${BOOT_DATA}/amlogic"
    cp "${BINARIES_DIR}/meson-sm1-jethome-jethub-j200.dtb" "${BOOT_DATA}/amlogic/"
    if ls "${BINARIES_DIR}"/*.dtbo 1> /dev/null 2>&1; then
        echo "Found .dtbo files in ${BINARIES_DIR}"
        mkdir -p "${BOOT_DATA}/overlays"
        cp "${BINARIES_DIR}"/*.dtbo "${BOOT_DATA}/overlays/"
    fi
}