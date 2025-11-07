#!/bin/bash

function fix_rootfs() {
    chmod +x "${BOARD_DIR}/rootfs-overlay/etc/wpa_action.sh"
    chmod +x "${BOARD_DIR}/rootfs-overlay/etc/init.d/S02fixnetwork"
}

function install_tini_docker() {
    ln -fs /usr/bin/tini "${TARGET_DIR}/usr/bin/docker-init"
}
