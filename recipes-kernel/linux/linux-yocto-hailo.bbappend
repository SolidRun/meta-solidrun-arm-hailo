FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-Fix-mxl-driver-build-for-a-broken-hailo-kernel-build.patch \
    file://0001-MXL8611X-support.patch \
    file://0002-Hailo-15-SolidRun-support.patch \
    file://0003-panel-ronbo-hailo.patch \
    file://0004-panel-ronbo-fix-gpio.patch \
    file://0005-input-touchscreen-ilitek-Use-gpiod_set_value_canslee.patch \
    file://0006-SOM-Rev-1.1.patch \
    file://0007-Enable-Hailo-SR-SoM-rev-1.1-and-1.0-co-support.patch \
    file://0008-Enable-uarts-2-and-3-with-USB.patch \
    file://0009-drop-vc8000e_reserved-now-CMA-based.patch \
    file://0010-renamed-sensor_0-label-and-deleted-imx334.patch \
    file://0012-hummingboard-iiot-hog-m2b-modem-power.patch \
    file://0013-imx678-do-not-hold-the-i2c-segment-lock-while-toggli.patch \
    file://0014-hummingboard-iiot-boot-LED-defaults.patch \
    file://0015-leds-lp55xx-set-the-chip-pointer-before-registering-the-LED.patch \
    file://0016-spi-advertise-the-QSPI-transfer-size-limit-through-spi-mux.patch \
    file://0017-leds-lp55xx-register-LEDs-with-their-device-tree-node.patch \
    file://0018-hummingboard-iiot-let-the-boot-LED-pattern-settle-on-the-final-colour.patch \
"

# defconfig
SRC_URI:append = " \
    file://solidrun-H15-SOM.cfg \
"

# Hailo's kernel bbappend used to add KERNEL_OVERLAYS to KERNEL_DEVICETREE (removed upstream in v1.9.0).
# Our U-Boot boots fitImage configuration "conf-hailo_hailo15-sr-som-v1-overlay.dtbo" on SOM rev 1.0.
KERNEL_DEVICETREE:append = " ${KERNEL_OVERLAYS}"
