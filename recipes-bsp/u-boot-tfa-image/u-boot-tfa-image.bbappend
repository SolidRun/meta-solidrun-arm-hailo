
# TODO: Alignement breaks Y-modem in SPL. This needs ferther investigation 

do_compile() {
    rm -f ${WORKDIR}/u-boot-nodtb.bin
    cp ${DEPLOY_DIR_IMAGE}/u-boot-nodtb.bin ${WORKDIR}/u-boot-nodtb.bin
    # align_file ${WORKDIR}/u-boot-nodtb.bin 64
    rm -f ${WORKDIR}/bl31.bin
    cp ${DEPLOY_DIR_IMAGE}/bl31.bin ${WORKDIR}/bl31.bin
    # align_file ${WORKDIR}/bl31.bin 64
    uboot-mkimage -f ${WORKDIR}/u-boot-tfa.its ${B}/u-boot-tfa.itb
    # sign u-boot-tfa with customer key
    uboot-mkimage -F -k ${SPL_SIGN_KEYDIR} -r ${B}/u-boot-tfa.itb
}
