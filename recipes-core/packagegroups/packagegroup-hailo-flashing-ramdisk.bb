SUMMARY = "Hailo fashing ramdisk packages"
DESCRIPTION = "The set of packages required to flash eMMC"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup
PACKAGES = "${PN}"

RDEPENDS:${PN} = "\
    bmap-tools \
    zstd \
"
