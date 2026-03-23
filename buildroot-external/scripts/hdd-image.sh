#!/bin/bash

function create_disk_image() {
    if [ ! -f "${BINARIES_DIR}/recovery.fit" ]; then
        echo "ERROR: recovery.fit not found in ${BINARIES_DIR}/"
        exit 1
    fi

    local fit_size
    fit_size=$(stat -c %s "${BINARIES_DIR}/recovery.fit")
    echo "recovery.fit ready: $((fit_size / 1024 / 1024)) MiB"
}
