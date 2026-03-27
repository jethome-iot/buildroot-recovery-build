function install_bootloader_config() {
    if [ "${BOOTLOADER}" == "uboot" ]; then
        # eMMC user area, offset 3.5 MiB (0x380000), size 64 KiB
        echo "/dev/mmcblk0 0x380000 0x10000" > "${TARGET_DIR}/etc/fw_env.config"
    fi
}
