FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot:"

# TODO: Use boot.scr instead of uEnv.txt.
#       See example recipe in meta-raspberrypi.

SRC_URI:append:beagleboneai = " file://uEnv.txt"

do_deploy:append () {
    cp -a ${WORKDIR}/uEnv.txt ${DEPLOYDIR}/
}
