SUMMARY = "OpenAVR Reference OS Image with development tools"

IMAGE_LINGUAS = " "

LICENSE = "MIT"

require recipes-core/images/core-image-openavr.bb

IMAGE_INSTALL += " \
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
