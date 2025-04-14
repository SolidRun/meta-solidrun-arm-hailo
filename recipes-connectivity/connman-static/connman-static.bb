FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

DESCRIPTION = "ConnMan static IP setup at boot using eth0 MAC"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://connman-static-ip-init.sh \
           file://connman_static_ip.init"

S = "${WORKDIR}"

do_install() {
    install -d ${D}/usr/libexec
    install -m 0755 ${WORKDIR}/connman-static-ip-init.sh ${D}/usr/libexec/

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${WORKDIR}/connman_static_ip.init ${D}${sysconfdir}/init.d/connman_static_ip

    install -d ${D}${sysconfdir}/rc5.d
    ln -s ../init.d/connman_static_ip ${D}${sysconfdir}/rc5.d/S02connman_static_ip
}

FILES_${PN} += " \
    /usr/libexec/connman-static-ip-init.sh \
    ${sysconfdir}/init.d/connman_static_ip \
    ${sysconfdir}/rc5.d/S02connman_static_ip \
"