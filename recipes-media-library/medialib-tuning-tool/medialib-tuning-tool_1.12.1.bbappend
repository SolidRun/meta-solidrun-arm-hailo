# Conflicts with pyhailort: /usr/bin/hailo

ROOTFS_CONFIGS_DIR = "${D}/usr/bin/hailo-tuning"


do_install() {
    # install config path on the rootfs
    install -d ${ROOTFS_CONFIGS_DIR}
    # copy the required files into the config path
    install -m 0755 -D  ${WORKDIR}/tuning-tool ${WORKDIR}/startup.sh ${ROOTFS_CONFIGS_DIR}
    # Create a symlink from /usr/bin/hailo-tuning/tuning-tool to /usr/bin/start-tuning
    ln -sf /usr/bin/hailo-tuning/startup.sh ${D}/usr/bin/hailo-tuning-tool
}

FILES:${PN} += "/usr/bin/hailo-tuning"