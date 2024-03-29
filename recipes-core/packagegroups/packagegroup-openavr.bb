SUMMARY = "OpenAVR packagegroups"

PACKAGE_ARCH = "${MACHINE_ARCH}"
inherit packagegroup

PROVIDES = "${PACKAGES}"
PACKAGES = "\
    ${PN} \
    ${PN}-net \
    ${PN}-wireless \
    ${PN}-mqtt \
"

RDEPENDS:${PN} = "\
    openssl-bin \
    cryptsetup \
    ca-certificates \
    bash \
    vim \
    usbutils \
    i2c-tools \
    minicom \
    screen \
    tmux \
    systemd-analyze \
"

RDEPENDS:${PN}-dev += "\
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

RDEPENDS:${PN}-net = "\
    socat \
    iperf2 \
    iperf3 \
    curl \
    strace \
    tcpdump \
    libnss-resolve2 \
    nftables \
"

RDEPENDS:${PN}-wireless = "\
    packagegroup-base-wifi \
    hostapd \
    modemmanager \
    dnsmasq \
"

RDEPENDS:${PN}-mqtt = "\
    mosquitto \
    mosquitto-config \
    mosquitto-clients \
    python3-paho-mqtt \
    lighttpd \
    lighttpd-module-accesslog \
"
