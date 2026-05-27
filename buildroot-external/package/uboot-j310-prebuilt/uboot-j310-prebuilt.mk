################################################################################
#
# uboot-j310-prebuilt
#
################################################################################

UBOOT_j310_PREBUILT_VERSION = 1.0
UBOOT_j310_PREBUILT_SITE = $(BR2_EXTERNAL_JHOS_PATH)/package/uboot-j310-prebuilt
UBOOT_j310_PREBUILT_SITE_METHOD = local
UBOOT_j310_PREBUILT_INSTALL_IMAGES = YES
UBOOT_j310_PREBUILT_LICENSE = Proprietary
UBOOT_j310_PREBUILT_REDISTRIBUTE = NO

# Always reinstall images (copy from source, not build dir)
define UBOOT_j310_PREBUILT_INSTALL_IMAGES_CMDS
	cp -f $(UBOOT_j310_PREBUILT_SITE)/u-boot.bin $(BINARIES_DIR)/
	cp -f $(UBOOT_j310_PREBUILT_SITE)/u-boot.bin.sd.bin $(BINARIES_DIR)/
	cp -f $(UBOOT_j310_PREBUILT_SITE)/u-boot.bin.usb $(BINARIES_DIR)/
endef

# Force rebuild on each invocation
UBOOT_j310_PREBUILT_ALWAYS_BUILD = YES

$(eval $(generic-package))
