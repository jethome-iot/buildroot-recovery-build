function install_bootloader_config() {
    if [ "${BOOTLOADER}" == "uboot" ]; then
        # U-Boot environment on raw eMMC; location comes from ${BOARD_DIR}/meta
        # (BOOT_ENV_DEV / BOOT_ENV_OFFSET / BOOT_ENV_SIZE)
        echo "${BOOT_ENV_DEV} ${BOOT_ENV_OFFSET} ${BOOT_ENV_SIZE}" > "${TARGET_DIR}/etc/fw_env.config"
    fi
}
