#!/bin/bash

function fix_rootfs() {

    #rm -f "${TARGET_DIR}/etc/wpa_supplicant.conf"

    chmod +x "${BOARD_DIR}/rootfs-overlay/etc_rofs/init.d/rcS" || true

}


function install_tini_docker() {
    ln -fs /usr/bin/tini "${TARGET_DIR}/usr/bin/docker-init"
}
