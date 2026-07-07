#!/bin/bash
# shellcheck disable=SC2155

function os_pre_image() {
    cp "${BOARD_DIR}/rescue.its" "${BINARIES_DIR}/"

    echo "Building recovery FIT image..."
    (cd "${BINARIES_DIR}" && mkimage -f rescue.its recovery.fit)

    local fit_size=$(stat -c %s "${BINARIES_DIR}/recovery.fit")
    local max_size=$((100 * 1024 * 1024))
    echo "recovery.fit size: $((fit_size / 1024 / 1024)) MiB"

    if [ "${fit_size}" -gt "${max_size}" ]; then
        echo "ERROR: recovery.fit exceeds 100 MiB slot limit (${fit_size} bytes)"
        exit 1
    fi
}
