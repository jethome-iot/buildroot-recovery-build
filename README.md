# JetHub Recovery System

Buildroot-based recovery system for JetHome JetHub devices. Produces a single `recovery.fit` FIT image containing Linux kernel, DTB, and initramfs.

## Supported boards

| Board | SoC | Kernel | Defconfig |
|-------|-----|--------|-----------|
| JetHub J310 | Amlogic S905Y5 (S7) | vendor 5.15 (`jethome-iot/linux-kernel`, `linux-s7-5.15`) | `jethub_j310_defconfig` |
| JetHub J100 (D1) | Amlogic A113X (AXG) | mainline 6.18.x | `jethub_j100_defconfig` |

Build a board with:

```
./buildroot.sh jethub_j100
```

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
| `Image` | Linux kernel (aarch64) |
| `meson-s7-jethub-j310.dtb` / `meson-axg-jethome-jethub-j100.dtb` | Device tree blob |
| `rootfs.cpio.lzma` | LZMA-compressed initramfs |

The FIT image must fit within the 100 MiB eMMC recovery slot.

For J100 the build additionally produces the recovery-aware bootloader: `output/images/u-boot.bin` and `u-boot.bin.sd.bin` (mainline U-Boot with the recovery/write-protect patches, FIP-wrapped for AXG).

## eMMC Layout

The recovery system occupies raw (unpartitioned) eMMC space before the main OS rootfs. Both boards use the same geometry:

```
| Offset      | Size    | Content                                        |
|-------------|---------|------------------------------------------------|
| 0–4 MiB     | 4 MiB   | U-Boot bootloader (env at 0x380000, 64 KiB)    |
| 4–132 MiB   | 128 MiB | Amlogic vendor areas (reserved/keys, env, gaps)|
| 132–234 MiB | 102 MiB | Recovery slot A (recovery.fit)                 |
| 234–336 MiB | 102 MiB | Recovery slot B (recovery.fit)                 |
| 336+ MiB    |         | Main OS partition (Armbian `OFFSET=336`)       |
```

In U-Boot sectors: slot A start `0x42000`, slot B start `0x75000`, slot size `0x33000`.

U-Boot detects the hardware recovery trigger (GPIO button) and loads `recovery.fit` from the active slot via `bootm`. On J100 the whole 0–336 MiB region is additionally power-on write-protected (`mmc wp user set`) on every normal boot, so the main OS cannot damage U-Boot or the recovery slots; the protection is intentionally not armed when entering recovery, and it clears on a full power cycle (recovery self-update therefore requires cold-boot entry into recovery).

The active slot is tracked by the `recovery_slot` U-Boot environment variable, managed from Linux through `fw_setenv`/`fw_printenv` (RAUC custom bootloader backend). The environment location is set per board in `board/jethome/<board>/meta` (`BOOT_ENV_DEV`/`BOOT_ENV_OFFSET`/`BOOT_ENV_SIZE`); both boards use offset `0x380000` (3.5 MiB, inside the U-Boot area), size 64 KiB.

## Board notes

### J310

U-Boot and kernel come from the JetHome vendor trees; the kernel DTB is taken from the vendor `common_drivers` directory, and modules for foreign Amlogic SoCs are pruned in `post-build.sh`. eMMC appears as `/dev/mmcblk1`.

### J100

Everything is mainline. eMMC is `/dev/mmcblk1` (the block device index follows the MMC host index: host 0 is the SDIO Wi-Fi controller, which creates no block device, host 1 is the eMMC).

Kernel: 6.18.x from kernel.org (DTS `amlogic/meson-axg-jethome-jethub-j100` is upstream since v5.16), configured by `board/jethome/kernel-mainline.config` — a trimmed, module-less recovery config (no DRM/media/sound/wireless/KVM/PCI) — plus the board fragment `board/jethome/jethub-j100/kernel-recovery.config` with the built-in drivers the recovery needs (notably `DWMAC_MESON` and `ICPLUS_PHY` for Ethernet).

U-Boot: mainline 2026.04 built by buildroot (`jethub_j100_defconfig`) with patches from `board/jethome/jethub-j100/patches/uboot/`:

- `0001` — `mmc wp user` command (power-on write protection of eMMC user-area WP groups);
- `0002` — recovery boot flow in `include/configs/jethub.h`: button `periphs-banks10` pressed → boot `recovery.fit` from slot A/B, released → arm write protect over 0–336 MiB and boot normally.

The config fragment `board/jethome/jethub-j100/uboot.config` stores the environment in eMMC (`0x380000`, 64 KiB, `ENV_MMC_DEVICE_INDEX=1`). The `amlogic-boot-fip-e` package wraps the built `u-boot.bin` with the Amlogic FIP blobs (`jethub-j100` board of the LibreELEC `amlogic-boot-fip` repo), so `output/images/u-boot.bin` and `u-boot.bin.sd.bin` are directly flashable; use them for `jethome-tools/bins/j100/`.
