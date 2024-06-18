FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
    file://squashfs.cfg \
    file://overlayfs.cfg \
    file://dm-verity.cfg \
"

KERNEL_CONFIG_FRAGMENTS:append = "\
    ${UNPACKDIR}/squashfs.cfg \
    ${UNPACKDIR}/overlayfs.cfg \
    ${UNPACKDIR}/dm-verity.cfg \
"
