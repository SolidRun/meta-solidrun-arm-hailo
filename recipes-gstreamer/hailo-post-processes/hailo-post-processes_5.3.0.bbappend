# (existing) Workaround: tappas meson.build doesn't accept the "hailo15" value
# that hailotools-base.bbclass passes via -Dtarget_platform.
do_configure:prepend() {
    sed -i "s|^elif target_platform == 'imx8'\$|elif target_platform in ['imx8', 'hailo15']|" \
        ${S}/meson.build
}

# Hailo (since v1.11, still in v1.12.1) ships TWO recipes that both install to /usr/lib/hailo-post-processes/:
#   - hailo-post-processes_5.3.0.bb (this recipe, legacy) ~22 unique .so files
#     PLUS 3 files that overlap with hailo-postprocess-tools
#   - hailo-postprocess-tools_1.12.1.bb (newer replacement) provides
#     4 unique .so files PLUS those same 3 overlapping files
#
# We keep BOTH installed (each provides unique libraries needed by demos).
# Delete the 3 overlapping files from this legacy package so the newer
# hailo-postprocess-tools versions are the ones present in the rootfs.
do_install:append() {
    rm -f ${D}${libdir}/hailo-post-processes/libocr_post.so
    rm -f ${D}${libdir}/hailo-post-processes/libyolo_post.so
    rm -f ${D}${libdir}/hailo-post-processes/libyolo_hailortpp_post.so

    # The gsthailometa header and .pc file are byte-identical copies of what
    # libgsthailotools-dev ships (both recipes build from the same tappas tree).
    # They are the only content of hailo-post-processes-dev, and opkg refuses to
    # install both -dev packages into the SDK sysroot (populate_sdk fails with a
    # file clash). Drop the copies; libgsthailotools-dev remains the provider.
    rm -f ${D}${includedir}/gsthailometa/gst_hailo_meta.hpp
    rmdir ${D}${includedir}/gsthailometa 2>/dev/null || true
    rm -f ${D}${libdir}/pkgconfig/gsthailometa.pc
    rmdir ${D}${libdir}/pkgconfig 2>/dev/null || true
}
