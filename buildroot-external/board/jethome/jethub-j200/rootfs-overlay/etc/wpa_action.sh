#!/bin/bash

IFACE="$1"
CMD="$2"

[ "$CMD" = "CONNECTED" ] || exit 0
logger -t wifi "CONNECTED on $IFACE — requesting DHCP"
udhcpc -i "$IFACE" -q -n -b > /dev/null 2>&1
