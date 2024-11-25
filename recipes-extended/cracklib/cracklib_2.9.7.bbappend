# Replace outdated branch value
python() {
    if 'SRC_URI' in d:
        src_uri = d.getVar('SRC_URI')
        # Replace branch=master with branch=main in SRC_URI
        src_uri = src_uri.replace('branch=master', 'branch=main')
        d.setVar('SRC_URI', src_uri)
}
