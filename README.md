# JetHub J310 Recovery System

Buildroot-based recovery system for [JetHome JetHub J310](Amlogic S905y5). Produces a single `recovery.fit` FIT image containing Linux kernel, DTB, and initramfs.

## Overview

The recovery system provides a minimal Linux environment with the `jrescue-app` application for:

- Network configuration
- Firmware download over the network
- Flashing firmware images to eMMC
- OLED display
- Web interface for remote management
- Console interface

## Build Output

The build produces `output/images/recovery.fit` — a U-Boot FIT image containing:

| Component | Description |
|-----------|-------------|
| `Image` | Linux 5.15 kernel (aarch64) |
| `meson-s7d-jethub-j310.dtb` | Device tree blob |
| `rootfs.cpio.lzma` | LZMA-compressed initramfs |

The FIT image must fit within the 100 MiB eMMC recovery slot.

## eMMC Layout

The recovery system occupies raw (unpartitioned) eMMC space before the Armbian rootfs:

```
| Offset      | Size    | Content                       |
|-------------|---------|-------------------------------|
| 0–4 MiB     | 4 MiB   | U-Boot bootloader             |
| 4–104 MiB   | 100 MiB | Recovery slot A (recovery.fit) |
| 104–204 MiB | 100 MiB | Recovery slot B (recovery.fit) |
| 204+ MiB    |         | Armbian rootfs partition      |
```

U-Boot detects the hardware recovery trigger (GPIO button) and loads `recovery.fit` from the active slot via `bootm`.