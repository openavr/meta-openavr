DESCRIPTION = "JOSE protocol implementation in Python using cryptography."
HOMEPAGE = "https://github.com/certbot/josepy"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=d2c2a5517cd7fd190a1aa6dfa23abb7a"

inherit pypi setuptools3

SRC_URI[md5sum] = "3ee02df055cd886aef94d56851a131d3"
SRC_URI[sha256sum] = "502a36f86efe2a6d09bf7018bca9fd8f8f24d8090a966aa037dbc844459ff9c8"

RDEPENDS_${PN} = "\
    ${PYTHON_PN}-cryptography (>=0.8) \
    ${PYTHON_PN}-pyopenssl (>=0.13) \
"
