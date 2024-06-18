FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "\
    file://overlayfs.cfg \
    file://squashfs.cfg \
"

KERNEL_CONFIG_FRAGMENTS += "\
    ${UNPACKDIR}/overlayfs.cfg \
    ${UNPACKDIR}/squashfs.cfg \
"
