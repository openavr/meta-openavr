SUMMARY = "OpenAVR Reference OS Image"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

# Base this image on core-image-base
include recipes-core/images/core-image-base.bb

IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"

IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_FEATURES += "package-management"
IMAGE_FEATURES += "read-only-rootfs"

IMAGE_FEATURES_remove = "splash"

IMAGE_INSTALL = " \
    packagegroup-core-boot \
    packagegroup-core-full-cmdline \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    packagegroup-openavr \
    packagegroup-openavr-net \
    packagegroup-openavr-wireless \
    networkd-config \
"

IMAGE_INSTALL_append_rpi = " \
    rpi-gpio \
    rpio \
"

# Need to install the kernel-image to get a kernel into the rootfs on the sdcard.
IMAGE_INSTALL += "kernel-image"
IMAGE_INSTALL += "kernel-modules"

IMAGE_INSTALL_append_raspberrypi4 = "linux-firmware-rpidistro-bcm43455"

inherit extrausers
EXTRA_USERS_PARAMS = "usermod -s /bin/bash root; "
