FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
    file://overlayfs.cfg \
"

KERNEL_CONFIG_FRAGMENTS += "\
    ${WORKDIR}/overlayfs.cfg \
"
