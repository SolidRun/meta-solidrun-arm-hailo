# Solidrun hailo15 SOM WiFi settings

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://brcmfmac43455-sdio.hailo,hailo15.txt \
"

do_install:append() {
    cp ${WORKDIR}/brcmfmac43455-sdio.hailo,hailo15.txt ${D}${nonarch_base_libdir}/firmware/brcm
    cd ${D}${nonarch_base_libdir}/firmware/brcm
    ln -s brcmfmac43455-sdio.bin brcmfmac43455-sdio.hailo,hailo15.bin
}
