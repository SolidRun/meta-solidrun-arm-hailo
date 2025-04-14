FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
    file://0001-phy-mxl-8611x-add-driver-for-MaxLinear-mxl-8611x-PHY.patch \
    file://0002-Merge-with-initial-patch-for-backporting.patch \
    file://0003-Fixup-for-device-tree-patch.patch \
    file://0004-lib-add-tlv_eeprom-library.patch \
    file://0005-cmd-tlv_eeprom-port-to-new-shared-tlv-library.patch \
    file://0006-lib-tlv_eeprom-add-getters-for-vendor-extension-fiel.patch \
    file://0007-net-Add-TCP-protocol.patch \
    file://0008-net-Add-wget-application.patch \
    file://0009-Hailo-15-SolidRun-initial-support.patch \
    file://0010-Read-macs-from-tlv-on-boot.patch \
    file://0011-Update-DDR-binding.patch \
    file://0012-Fix-eMMC-drive-strength-in-the-u-boot.patch \
    file://0013-SR-carrier-selection-support.patch \
    file://0014-Wifi-Support.patch \
    file://0015-SR-SOM-keep-only-valid-and-stable-menu-entries.patch \
    file://0016-SR-SOM-SPL-Schange-fallback-do-mmc2-and-uart.patch \
    file://0017-hailo15-solidrun-option-to-force-uart-boot-with-gpio.patch \
    file://0018-hailo15-solidrun-swupdate-support.patch \
    file://0019-gpio-Enable-hogging-support-in-SPL.patch \
    file://0020-hailo15-gpio-support-for-SPL.patch \
    file://0021-Set-machine-name-in-the-u-boot-env.patch \
    file://0022-Enable-SOM-rev-1.0-and-1.1-cosupport-for-a-single-u-.patch \
    file://0023-TLV-Lib-Make-default-mac-count-1.patch \
    file://0024-Remove-gpio8-from-u-boot-pinctr-conflict-with-rev-1.patch \
"