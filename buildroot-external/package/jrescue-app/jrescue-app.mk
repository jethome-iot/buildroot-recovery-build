################################################################################
#
# jrescue-app
#
################################################################################

JRESCUE_APP_VERSION = 2.0.3
JRESCUE_APP_SITE = https://github.com/jethome-iot/jrescue-app/releases/download/v$(JRESCUE_APP_VERSION)
JRESCUE_APP_SOURCE = jrescue-app-$(JRESCUE_APP_VERSION).tar.gz
JRESCUE_APP_LICENSE = Proprietary
JRESCUE_APP_REDISTRIBUTE = NO
JRESCUE_APP_DEPENDENCIES = python3 python-pillow python-evdev

JRESCUE_APP_TARGET = /usr/lib/jrescue-app
JRESCUE_APP_COMPONENTS = core console-application oled-grid-application web-application

define JRESCUE_APP_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)$(JRESCUE_APP_TARGET)
	for c in $(JRESCUE_APP_COMPONENTS); do \
		cp -a $(@D)/$$c $(TARGET_DIR)$(JRESCUE_APP_TARGET)/ ; \
	done
endef

$(eval $(generic-package))
