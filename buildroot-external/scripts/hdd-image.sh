#!/bin/bash

SYSTEM_SIZE=18M
KERNEL_SIZE=7M

function create_disk_image() {
    if [ -f "${BOARD_DIR}/genimage-spi.cfg" ]; then
      echo "Using custom genimage-spi.cfg from ${BOARD_DIR}"
    else
      echo "Using default genimage.cfg"
    fi

    export GENIMAGE_INPUTPATH="${BINARIES_DIR}"
    export GENIMAGE_OUTPUTPATH="${BINARIES_DIR}"
    export GENIMAGE_TMPPATH="${BUILD_DIR}/genimage.tmp"

    # variables from meta file
    export BOARD_ID DISK_SIZE BOOTLOADER KERNEL_FILE PARTITION_TABLE_TYPE BOOT_SIZE BOOT_SPL BOOT_SPL_SIZE
    # variables used in raucb manifest template
    # variables used in genimage configs
    export BOOTSTATE_SIZE SYSTEM_SIZE KERNEL_SIZE OVERLAY_SIZE DATA_SIZE
    IMAGE_NAME="$(os_image_basename)"
    BOOT_SPL_TYPE=$(test "$BOOT_SPL" == "true" && echo "spl" || echo "nospl")
    export RAUC_MANIFEST IMAGE_NAME BOOT_SPL_TYPE

    trap 'rm -rf "${ROOTPATH_TMP}" "${GENIMAGE_TMPPATH}"' EXIT
    ROOTPATH_TMP="$(mktemp -d)"

    rm -rf "${GENIMAGE_TMPPATH}"

    genimage \
      --rootpath "${ROOTPATH_TMP}" \
      --configdump - \
      --tmppath "$GENIMAGE_TMPPATH" \
      --outputpath "${BINARIES_DIR}" \
      --config "${BOARD_DIR}/genimage-spi.cfg"

    genimage \
      --rootpath "${ROOTPATH_TMP}" \
      --tmppath "$GENIMAGE_TMPPATH" \
      --outputpath "${BINARIES_DIR}" \
      --config "${BOARD_DIR}/genimage-sdspi.cfg"

    genimage \
      --rootpath "${ROOTPATH_TMP}" \
      --tmppath "$GENIMAGE_TMPPATH" \
      --outputpath "${BINARIES_DIR}" \
      --config "${BOARD_DIR}/genimage-sd.cfg"
}
