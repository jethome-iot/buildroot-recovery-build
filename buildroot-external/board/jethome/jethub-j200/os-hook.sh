#!/bin/bash
# shellcheck disable=SC2155

# shellcheck source=../../../scripts/burn.sh
. "${SCRIPT_DIR}/burn.sh"

function os_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"
    dd if=/dev/zero of="${BINARIES_DIR}/env.blank" bs=64K count=1
    lzma -f -k -9 "${BINARIES_DIR}/Image"

    mkdir -p sdimage
    cp "${BINARIES_DIR}/spi-nor.img" sdimage || true
    SIZE_KB=$(du -sk sdimage | awk '{print int($1 * 1.1)}') || true
    genext2fs -d sdimage -b "$SIZE_KB" "${BINARIES_DIR}/spiimage.ext4" || true
    rm -rf sdimage

    cp "${BINARIES_DIR}/boot.scr" "${BOOT_DATA}/boot.scr"
    mkdir -p "${BOOT_DATA}/amlogic"
    cp "${BINARIES_DIR}/meson-sm1-jethome-jethub-j200.dtb" "${BOOT_DATA}/amlogic/"
    if ls "${BINARIES_DIR}"/*.dtbo 1> /dev/null 2>&1; then
        echo "Found .dtbo files in ${BINARIES_DIR}"
        mkdir -p "${BOOT_DATA}/overlays"
        cp "${BINARIES_DIR}"/*.dtbo "${BOOT_DATA}/overlays/"
    fi
    cp "${BOARD_DIR}/boot-env.txt" "${BOOT_DATA}/os-config.txt" || true
    cp "${BOARD_DIR}/cmdline.txt" "${BOOT_DATA}/cmdline.txt"
}

function os_post_image() {
    convert_disk_image_xz
    # support for create AmLogic burnable images
    [[ -f "${BINARIES_DIR}/platform.conf" ]] && _create_disk_burn
    [[ -f "${BINARIES_DIR}/platform.conf" ]] && convert_disk_image_burn_zip
}
