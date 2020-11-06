SUMMARY = "OpenAVR packagegroups"

PR = "r1"

PACKAGE_ARCH = "${MACHINE_ARCH}"
inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = "\
    ${PN} \
    ${PN}-net \
    ${PN}-wireless \
"

RDEPENDS_${PN} = "\
    bash \
    vim \
    usbutils \
    i2c-tools \
    minicom \
    screen \
    tmux \
"

RDEPENDS_${PN}-dev += "\
    packagegroup-sdk-target \
    kexec-tools \
    kdump \
    crash \
    makedumpfile \
    kernel-dev \
    kernel-devsrc \
    kernel-devsrc-dbg \
    dtc \
    git \
"

RDEPENDS_${PN}-net = "\
    socat \
    iperf2 \
    iperf3 \
    curl \
    strace \
    tcpdump \
"

RDEPENDS_${PN}-wireless = "\
    packagegroup-base-wifi \
    hostapd \
"
