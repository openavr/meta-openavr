SUMMARY = "OpenAVR Reference OS Image with development tools"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

include recipes-core/images/core-image-openavr.inc

IMAGE_INSTALL += " \
    packagegroup-openavr-dev \
"
