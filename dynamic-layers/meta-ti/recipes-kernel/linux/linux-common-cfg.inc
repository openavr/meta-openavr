FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = "\
    file://squashfs.cfg \
    file://overlayfs.cfg \
    file://dm-verity.cfg \
"

KERNEL_CONFIG_FRAGMENTS:append = "\
    ${WORKDIR}/squashfs.cfg \
    ${WORKDIR}/overlayfs.cfg \
    ${WORKDIR}/dm-verity.cfg \
"
