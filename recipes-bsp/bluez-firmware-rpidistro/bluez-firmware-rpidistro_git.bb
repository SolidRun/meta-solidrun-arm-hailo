SUMMARY = "Bluetooth patch firmware for the CYW43455 (BCM4345C0) module on the SolidRun Hailo-15 SOM"
DESCRIPTION = "The Bluetooth core of the Cypress/Infineon CYW43455 boots from ROM and needs a patch \
file (BCM4345C0.hcd) loaded by the kernel (hci_uart_bcm). Upstream linux-firmware does not ship it. \
This recipe takes the file redistributed by the Raspberry Pi Foundation (Raspberry Pi 3B+ build, same \
37.4 MHz WLBGA reference design as this module) under the Cypress Wireless Connectivity Devices EULA, \
the same way meta-raspberrypi does."
HOMEPAGE = "https://github.com/RPi-Distro/bluez-firmware"
SECTION = "kernel"

# Cypress EULA: binary redistribution allowed solely for use with Cypress integrated circuit products.
# The text is embedded in debian/copyright; it is extracted into LICENCE.cypress-rpidistro below.
LICENSE = "Firmware-cypress-rpidistro"
NO_GENERIC_LICENSE[Firmware-cypress-rpidistro] = "LICENCE.cypress-rpidistro"
LIC_FILES_CHKSUM = "file://LICENCE.cypress-rpidistro;md5=390f8ff2177baa58de0a0a67d2942f2e"

SRC_URI = "git://github.com/RPi-Distro/bluez-firmware;branch=bookworm;protocol=https"
# 1.2-9+rpt4 (2025-10-02): debian/firmware/broadcom/BCM4345C0.hcd, 63806 bytes
SRCREV = "adb4d55c8f193ff16ece74dd72fd6e8801632103"
PV = "1.2-9+rpt4"
S = "${WORKDIR}/git"

inherit allarch

# The EULA is the stand-alone "License:" stanza between the CYPRESS and SYNAPTICS markers
# (last occurrence of each: the earlier ones are references from "Files:" stanzas).
do_extract_lic() {
    start=$(grep -n '^License: CYPRESS-WIRELESS-CONNECTIVITY' ${S}/debian/copyright | tail -1 | cut -d: -f1)
    end=$(grep -n '^License: SYNAPTICS' ${S}/debian/copyright | tail -1 | cut -d: -f1)
    [ -n "$start" ] && [ -n "$end" ] || bbfatal "Cypress EULA markers not found in debian/copyright"
    start=$(expr $start + 1)
    end=$(expr $end - 1)
    sed -n "${start},${end}p" ${S}/debian/copyright | sed 's/^ //; s/^\.$//' > ${S}/LICENCE.cypress-rpidistro
}
addtask extract_lic after do_unpack before do_patch do_populate_lic

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${nonarch_base_libdir}/firmware/brcm
    install -m 0644 ${S}/debian/firmware/broadcom/BCM4345C0.hcd ${D}${nonarch_base_libdir}/firmware/brcm/
    install -m 0644 ${S}/LICENCE.cypress-rpidistro ${D}${nonarch_base_libdir}/firmware/
}

PACKAGES = "${PN}-cypress-license ${PN}-bcm4345c0-hcd"
FILES:${PN}-cypress-license = "${nonarch_base_libdir}/firmware/LICENCE.cypress-rpidistro"
FILES:${PN}-bcm4345c0-hcd = "${nonarch_base_libdir}/firmware/brcm/BCM4345C0.hcd"
RDEPENDS:${PN}-bcm4345c0-hcd += "${PN}-cypress-license"
