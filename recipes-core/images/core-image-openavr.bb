SUMMARY = "OpenAVR Core Reference OS Image"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

inherit core-image

IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE_append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "" ,d)}"

IMAGE_FEATURES += "ssh-server-openssh"
IMAGE_FEATURES += "package-management"

IMAGE_INSTALL = " \
    packagegroup-core-boot \
    packagegroup-core-full-cmdline \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    networkd-config \
    bash \
    vim \
    usbutils \
    i2c-tools \
    minicom \
    screen \
    tmux \
    socat \
    iperf2 \
    iperf3 \
    curl \
    strace \
"

# Need to install the kernel-image to get a kernel into the rootfs on the sdcard.
IMAGE_INSTALL += "kernel-image"
IMAGE_INSTALL += "kernel-modules"

inherit extrausers
EXTRA_USERS_PARAMS = "usermod -s /bin/bash root; "
