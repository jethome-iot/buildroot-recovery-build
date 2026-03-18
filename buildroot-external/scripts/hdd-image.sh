#!/bin/bash

function create_disk_image() {
    export GENIMAGE_INPUTPATH="${BINARIES_DIR}"
    export GENIMAGE_OUTPUTPATH="${BINARIES_DIR}"
    export GENIMAGE_TMPPATH="${BUILD_DIR}/genimage.tmp"

    export BOARD_ID DISK_SIZE BOOTLOADER KERNEL_FILE PARTITION_TABLE_TYPE BOOT_SIZE BOOT_SPL BOOT_SPL_SIZE
    export BOOTSTATE_SIZE SYSTEM_SIZE KERNEL_SIZE OVERLAY_SIZE DATA_SIZE
    IMAGE_NAME="$(os_image_basename)"
    BOOT_SPL_TYPE=$(test "$BOOT_SPL" == "true" && echo "spl" || echo "nospl")
    export RAUC_MANIFEST IMAGE_NAME BOOT_SPL_TYPE

    trap 'rm -rf "${ROOTPATH_TMP}" "${GENIMAGE_TMPPATH}"' EXIT
    ROOTPATH_TMP="$(mktemp -d)"

    rm -rf "${GENIMAGE_TMPPATH}"

    genimage \
      --rootpath "${ROOTPATH_TMP}" \
      --tmppath "$GENIMAGE_TMPPATH" \
      --outputpath "${BINARIES_DIR}" \
      --config "${BOARD_DIR}/genimage-rescue.cfg"
}
