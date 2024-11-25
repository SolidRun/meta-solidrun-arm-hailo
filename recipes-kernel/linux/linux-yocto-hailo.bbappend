FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-Fix-mxl-driver-build-for-a-broken-hailo-kernel-build.patch \
    file://0001-MXL8611X-support.patch \
    file://0002-Hailo-15-SolidRun-support.patch \
    file://0003-panel-ronbo-hailo.patch \
    file://0004-panel-ronbo-fix-gpio.patch \
    file://0005-input-touchscreen-ilitek-Use-gpiod_set_value_canslee.patch \
"

# defconfig
SRC_URI:append = " \
    file://solidrun-H15-SOM.cfg \
"
