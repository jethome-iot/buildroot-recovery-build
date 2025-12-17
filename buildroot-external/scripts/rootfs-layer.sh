#!/bin/bash

function fix_rootfs() {
    chmod +x "${BOARD_DIR}/rootfs-overlay/etc/wpa_action.sh"
    chmod +x "${BOARD_DIR}/rootfs-overlay/etc/init.d/S02fixnetwork"
    chmod +x "${BOARD_DIR}/rootfs-overlay/sbin/usb-mount.sh"
}
