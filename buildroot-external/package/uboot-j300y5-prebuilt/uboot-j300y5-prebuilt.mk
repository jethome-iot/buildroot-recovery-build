################################################################################
#
# uboot-j300y5-prebuilt
#
################################################################################

UBOOT_J300Y5_PREBUILT_VERSION = 1.0
UBOOT_J300Y5_PREBUILT_SITE = $(BR2_EXTERNAL_JHOS_PATH)/package/uboot-j300y5-prebuilt
UBOOT_J300Y5_PREBUILT_SITE_METHOD = local
UBOOT_J300Y5_PREBUILT_INSTALL_IMAGES = YES
UBOOT_J300Y5_PREBUILT_LICENSE = Proprietary
UBOOT_J300Y5_PREBUILT_REDISTRIBUTE = NO

# Always reinstall images (copy from source, not build dir)
define UBOOT_J300Y5_PREBUILT_INSTALL_IMAGES_CMDS
	cp -f $(UBOOT_J300Y5_PREBUILT_SITE)/u-boot.bin $(BINARIES_DIR)/
	cp -f $(UBOOT_J300Y5_PREBUILT_SITE)/u-boot.bin.sd.bin $(BINARIES_DIR)/
	cp -f $(UBOOT_J300Y5_PREBUILT_SITE)/u-boot.bin.usb $(BINARIES_DIR)/
endef

# Force rebuild on each invocation
UBOOT_J300Y5_PREBUILT_ALWAYS_BUILD = YES

$(eval $(generic-package))
