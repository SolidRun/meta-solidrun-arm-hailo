# Change default TERM to xterm

do_install:append(){
    sed -i 's/vt102/xterm/g' ${D}${sysconfdir}/inittab
}
