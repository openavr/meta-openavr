do_deploy_append() {
    sed -i '/#initramfs / c\initramfs initramfs.cpio.gz' ${DEPLOYDIR}/${BOOTFILES_DIR_NAME}/config.txt
}
