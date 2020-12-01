DESCRIPTION = "Zope Deferred Import Module"
HOMEPAGE = "https://github.com/zopefoundation/zope.deferredimport"
LICENSE = "ZPL-2.1"
LIC_FILES_CHKSUM = "file://LICENSE.txt;md5=78ccb3640dc841e1baecb3e27a6966b2"

PYPI_PACKAGE = "zope.deferredimport"

inherit pypi setuptools3

SRC_URI[md5sum] = "9fb87ae9f3467411e8ec7844b4792926"
SRC_URI[sha256sum] = "57b2345e7b5eef47efcd4f634ff16c93e4265de3dcf325afc7315ade48d909e1"

RDEPENDS_${PN} = "\
    python3-zopeproxy \
"
