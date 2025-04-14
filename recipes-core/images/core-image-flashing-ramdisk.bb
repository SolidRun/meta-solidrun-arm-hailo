LICENSE = "MIT"
# require recipes-core/images/core-image-base.bb
# IMAGE_INSTALL:remove = "packagegroup-hailo-tappas-dev-pkg x264 gstreamer1.0-plugins-ugly bluez5"
# IMAGE_INSTALL:append = " bmap-tools"
IMAGE_FSTYPES:remove = "wic wic.zst wic.bmap etx4"
INITRAMFS_FSTYPES = "cpio.gz"
IMAGE_FSTYPES = "${INITRAMFS_FSTYPES}"
EXTRA_IMAGEDEPENDS:remove = "u-boot-tfa-image"

IMAGE_INSTALL = "packagegroup-core-boot \
                packagegroup-base-extended \
                packagegroup-hailo-flashing-ramdisk \
                kernel-modules \
"

inherit image
