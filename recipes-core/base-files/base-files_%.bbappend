FILESEXTRAPATHS_append := "${THISDIR}/${PN}:"

hostname = "openavr-dev"

do_install_append() {
    install -m 755 -d ${D}/config
    install -m 755 -d ${D}/data
}

FILES_${PN} += "\
    /config \
    /data \
"
