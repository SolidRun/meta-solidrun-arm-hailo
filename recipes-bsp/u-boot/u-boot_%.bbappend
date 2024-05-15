FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://0001-MXL8611X-support.patch \
    file://0002-tlv-lib.patch \
    file://0003-Hailo-15-SolidRun-initial-support.patch \
"
