FILESEXTRAPATHS_prepend := "${THISDIR}/${PN}:"

SRC_URI_append_beagleboneai = "\
    file://0001-Fix-broken-ethernet-on-beaglebone-ai.patch \
"
