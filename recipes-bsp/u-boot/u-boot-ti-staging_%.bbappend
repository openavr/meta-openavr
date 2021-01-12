FILESEXTRAPATHS_prepend := "${THISDIR}/u-boot:"

# TODO: Use boot.scr instead of uEnv.txt.
#       See example recipe in meta-raspberrypi.

SRC_URI_append_beagleboneai = " file://uEnv.txt"

do_deploy_append () {
    cp -a ${WORKDIR}/uEnv.txt ${DEPLOYDIR}/
}
