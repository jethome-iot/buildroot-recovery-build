#!/bin/bash

function fix_rootfs() {

    chmod +x "${BOARD_DIR}/rootfs-overlay/etc/wpa_action.sh"
    chmod +x "${BOARD_DIR}/rootfs-overlay/etc/hotplug.d/iface/10-dhcp"
    chmod +x "${BOARD_DIR}/rootfs-overlay/etc/init.d/S02fixnetwork"
    chmod +x "${BOARD_DIR}/rootfs-overlay/etc/init.d/wifi_setup.sh"

}


function install_tini_docker() {
    ln -fs /usr/bin/tini "${TARGET_DIR}/usr/bin/docker-init"
}
