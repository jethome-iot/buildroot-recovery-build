#!/bin/bash
# shellcheck disable=SC2155

# shellcheck source=../../../scripts/burn.sh
. "${SCRIPT_DIR}/burn.sh"

function os_pre_image() {
    local BOOT_DATA="$(path_boot_dir)"

    lzma -f -k -9 "${BINARIES_DIR}/Image"

    #mkimage -A arm64 -O linux -T kernel -C lzma \
    #-a 0x08200000 -e 0x08200000 \
    #-n "JetHub Kernel (LZMA)" \
    #-d "${BINARIES_DIR}/Image.lzma" "${BINARIES_DIR}/uImage"

    mkdir -p kernel_root
    cp "${BINARIES_DIR}/Image.lzma" kernel_root/
    SIZE_KB=$(du -sk kernel_root | awk '{print int($1 * 1.3)}')
    genext2fs -d kernel_root -b "$SIZE_KB" "${BINARIES_DIR}/kernel.ext4"
    rm -rf kernel_root

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
