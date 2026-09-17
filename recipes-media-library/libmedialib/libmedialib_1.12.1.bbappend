FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-sensor_registry-accept-any-i2c-bus-for-sensor-0.patch \
"
