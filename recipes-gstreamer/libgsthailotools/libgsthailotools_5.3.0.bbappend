# Same workaround as hailo-post-processes_5.3.0.bbappend.
do_configure:prepend() {
    sed -i "s|^elif target_platform == 'imx8'\$|elif target_platform in ['imx8', 'hailo15']|" \
        ${S}/meson.build
}
