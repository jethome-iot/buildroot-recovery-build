#!/usr/bin/env bash

# Called automatically when /dev/sdXN appears/disappears

DEV="$MDEV"
DEVPATH="/dev/$DEV"
BASE="/mnt/usb"
ACTION="${ACTION:-add}"

log() { echo "[usb-mount] $*"; }

find_mountpoint() {
    MP=$(grep "^$DEVPATH " /proc/mounts | awk '{print $2}')
    if [ -n "$MP" ]; then
        echo "$MP"
        return 0
    fi

    if [ ! -e "$BASE" ]; then
        echo "$BASE"
        return 0
    fi

    i=1
    while true; do
        MP="${BASE}${i}"
        if [ ! -e "$MP" ]; then
            echo "$MP"
            return 0
        fi
        if ! grep -q " $MP " /proc/mounts; then
            echo "$MP"
            return 0
        fi
        i=$((i + 1))
    done
}

do_mount() {
    # Check if already mounted
    if grep -q "^$DEVPATH " /proc/mounts; then
        log "$DEVPATH already mounted"
        return 0
    fi

    MP=$(find_mountpoint)
    mkdir -p "$MP"

    # read-only mount
    mount -o ro "$DEVPATH" "$MP"
    if [ $? -eq 0 ]; then
        log "mounted $DEVPATH at $MP"
    else
        log "mount failed for $DEVPATH"
        rmdir "$MP" 2>/dev/null
    fi
}

do_umount() {
    MP=$(grep "^$DEVPATH " /proc/mounts | awk '{print $2}')
    if [ -n "$MP" ]; then
        umount "$MP"
        if [ $? -eq 0 ]; then
            log "unmounted $DEVPATH from $MP"
            rmdir "$MP" 2>/dev/null
        else
            log "umount failed for $DEVPATH"
        fi
    fi
}

case "$ACTION" in
    add)    do_mount ;;
    remove) do_umount ;;
    *)      log "unknown ACTION=$ACTION" ;;
esac
