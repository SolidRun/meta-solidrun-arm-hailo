# Default static ip
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://ethernet_eth0_cable.config \
"

do_install:append(){
    install -d ${D}/${localstatedir}/lib/connman
    cp ${WORKDIR}/ethernet_eth0_cable.config ${D}/${localstatedir}/lib/connman
}
