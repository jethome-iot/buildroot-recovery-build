#!/bin/bash

function fix_rootfs() {

    chmod +x "${BOARD_DIR}/rootfs-overlay/etc/init.d/rcS"

}


function install_tini_docker() {
    ln -fs /usr/bin/tini "${TARGET_DIR}/usr/bin/docker-init"
}
