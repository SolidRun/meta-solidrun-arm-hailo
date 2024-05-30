FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-MXL8611X-support.patch \
    file://0002-Hailo-15-SolidRun-initial-support.patch \
"

# defconfig
SRC_URI:append = " \
    file://solidrun-H15-SOM.cfg \
"

#WIFI/BT

SRC_URI:append = " \
    file://0001-Enable-wifi-and-bt.patch \
"
