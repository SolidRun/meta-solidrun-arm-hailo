FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-Fix-kernel-symlinks.patch \
    file://0001-MXL8611X-support.patch \
    file://0002-Hailo-15-SolidRun-support.patch \
    file://0004-panel-ronbo-fix-gpio.patch \
"

# Temporary, unless merged into hailo BSP
SRC_URI:append = " \
    file://0003-emmc-tunning.patch \ 
    file://0005-panel-ronbo-hailo.patch \
"

# defconfig
SRC_URI:append = " \
    file://solidrun-H15-SOM.cfg \
"
