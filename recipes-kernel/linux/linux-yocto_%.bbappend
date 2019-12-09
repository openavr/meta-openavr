FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
    file://overlayfs.cfg \
    file://squashfs.cfg \
"

KERNEL_CONFIG_FRAGMENTS += "\
    ${WORKDIR}/overlayfs.cfg \
    ${WORKDIR}/squashfs.cfg \
"
