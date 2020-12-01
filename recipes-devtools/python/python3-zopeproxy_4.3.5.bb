DESCRIPTION = "Zope Component Architecture"
HOMEPAGE = "https://github.com/zopefoundation/zope.proxy"
LICENSE = "ZPL-2.1"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=78ccb3640dc841e1baecb3e27a6966b2"

PYPI_PACKAGE = "zope.proxy"

inherit pypi setuptools3

SRC_URI[md5sum] = "2d102d9c22a81be04d9de7548c23b2a2"
SRC_URI[sha256sum] = "a66a0d94e5b081d5d695e66d6667e91e74d79e273eee95c1747717ba9cb70792"

RDEPENDS_${PN} = "\
    python3-zopeinterface \
"
