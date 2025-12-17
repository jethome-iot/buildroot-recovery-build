function install_bootloader_config() {
    if [ "${BOOTLOADER}" == "uboot" ]; then
        # fw_env.config for fw_printenv/fw_setenv (u-boot-tools).
        # Note: Linux may expose the whole SPI-NOR as mtd0 (master device),
        # and partitions as mtd1..N (mtd0=spi0.0, mtd1=uboot, mtd2=env, ...).
        if [ "${BOARD_ID}" = "jethub-d2" ]; then
            echo "/dev/mtd2 0x0 0x10000" > "${TARGET_DIR}/etc/fw_env.config"
        else
            # shellcheck disable=SC1117
            echo "/dev/mtd3 0x0 0x10000" > "${TARGET_DIR}/etc/fw_env.config"
        fi
    fi
}
