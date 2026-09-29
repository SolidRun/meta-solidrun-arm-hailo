# Replace outdated SRC_URI

SRC_URI:remove = "git://anongit.freedesktop.org/git/virglrenderer;branch=branch-0.9.1"
SRC_URI:append = " git://gitlab.freedesktop.org/virgl/virglrenderer.git;protocol=https;branch=branch-0.9.1"