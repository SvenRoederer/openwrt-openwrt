DEVICE_VARS += UBNT_BOARD UBNT_CHIP UBNT_TYPE UBNT_VERSION UBNT_REVISION

# On M (XW) devices the U-Boot as of version 1.1.4-s1039 doesn't like
# VERSION_DIST being on the place of major(?) version number, so we need to
# use some number.
UBNT_REVISION := $(VERSION_DIST)-$(REVISION)

# mkubntimage is using the kernel image direct
# routerboard creates partitions out of the ubnt header
define Build/mkubntimage
	-$(STAGING_DIR_HOST)/bin/mkfwimage -B $(UBNT_BOARD) \
		-v $(UBNT_TYPE).$(UBNT_CHIP).v6.0.0-$(VERSION_DIST)-$(REVISION) \
		-k $(IMAGE_KERNEL) -r $@ -o $@
endef

# all UBNT XM/WA devices expect the kernel image to have 1024k while flash, when
# booting the image, the size doesn't matter.
define Build/mkubntimage-split
	-[ -f $@ ] && ( \
	dd if=$@ of=$@.old1 bs=1024k count=1; \
	dd if=$@ of=$@.old2 bs=1024k skip=1; \
	$(STAGING_DIR_HOST)/bin/mkfwimage -B $(UBNT_BOARD) \
		-v $(UBNT_TYPE).$(UBNT_CHIP).v$(UBNT_VERSION)-$(UBNT_REVISION) \
		-k $@.old1 -r $@.old2 -o $@; \
	rm $@.old1 $@.old2 )
endef

# UBNT_BOARD e.g. one of (XS2, XS5, RS, XM)
# UBNT_TYPE e.g. one of (BZ, XM, XW)
# UBNT_CHIP e.g. one of (ar7240, ar933x, ar934x)
# UBNT_VERSION e.g. one of (6.0.0, 8.5.3)
define Device/ubnt
  DEVICE_VENDOR := Ubiquiti
  IMAGES += factory.bin
  IMAGE/factory.bin := append-kernel | pad-to $$$$(BLOCKSIZE) | \
	append-rootfs | pad-rootfs | check-size | mkubntimage-split
endef

define Device/ubnt-xm
  $(Device/ubnt)
  DEVICE_VARIANT := XM
  IMAGE_SIZE := 7448k
  UBNT_BOARD := XM
  UBNT_CHIP := ar7240
  UBNT_TYPE := XM
  UBNT_VERSION := 6.0.0
  KERNEL := kernel-bin | append-dtb | relocate-kernel | lzma | uImage lzma
endef

define Device/ubnt_airrouter
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := AirRouter
  SUPPORTED_DEVICES += airrouter
endef
TARGET_DEVICES += ubnt_airrouter

define Device/ubnt_bullet-m-ar7240
  $(Device/ubnt-xm)
  SOC := ar7240
  DEVICE_MODEL := Bullet M
  DEVICE_VARIANT := XM (AR7240)
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m
endef
TARGET_DEVICES += ubnt_bullet-m-ar7240

define Device/ubnt_bullet-m-ar7241
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := Bullet M
  DEVICE_VARIANT := XM (AR7241)
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m ubnt,bullet-m
endef
TARGET_DEVICES += ubnt_bullet-m-ar7241

define Device/ubnt_nanobridge-m
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := NanoBridge M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m
endef
TARGET_DEVICES += ubnt_nanobridge-m

define Device/ubnt_nanostation-loco-m
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := Nanostation Loco M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m
endef
TARGET_DEVICES += ubnt_nanostation-loco-m

define Device/ubnt_nanostation-m
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := Nanostation M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += nanostation-m
endef
TARGET_DEVICES += ubnt_nanostation-m

define Device/ubnt_picostation-m
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := Picostation M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m
endef
TARGET_DEVICES += ubnt_picostation-m

define Device/ubnt_powerbridge-m
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := PowerBridge M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += bullet-m
endef
TARGET_DEVICES += ubnt_powerbridge-m

define Device/ubnt_rocket-m
  $(Device/ubnt-xm)
  SOC := ar7241
  DEVICE_MODEL := Rocket M
  DEVICE_PACKAGES += rssileds
  SUPPORTED_DEVICES += rocket-m
endef
TARGET_DEVICES += ubnt_rocket-m
