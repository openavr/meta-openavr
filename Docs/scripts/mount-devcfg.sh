#!/bin/bash
#
# Script to be run on a device to validate and mount a signed squashfs images with dm-verity.

cd /config

DEVCFG=( $(echo devcfg-*.squashfs) )

if [ ${#DEVCFG[@]} -gt 1 ]
then
    echo "Multiple devcfg files found:"
    for d in "${DEVCFG[@]}"; do
        echo "    $d"
    done
    exit 1
fi

if [ ! -f ${DEVCFG} ]
then
    echo "Missing devcfg file: ${DEVCFG}"
    exit 1
fi

META_OFFSET=$(( $(stat -c '%s' ${DEVCFG}) - 4096 ))

set -x

# Extract the meta data tarball from the end of the squashfs file (last 4K)
dd if=${DEVCFG} bs=1 skip=${META_OFFSET} | tar xz

# Verify the signing cert against the OpenAVR Root CA certs embedded
# in the rootfs image.
openssl verify devcfg-signing.crt || exit 1

# Verify the info file.
openssl x509 -pubkey -in devcfg-signing.crt > devcfg-signing.pub
openssl dgst -sha256 -verify devcfg-signing.pub \
    -signature ${DEVCFG}.info.sig ${DEVCFG}.info || exit 1

# Now that we trust the ${DEVCF}.info file, we can source it to use the
# ROOT_HASH and DATA_SIZE variables in it.
source ${DEVCFG}.info

# Since we trust the info file, we explicitly trust the dm-verity
# ROOT_HASH of the squashfs and can mount the squashfs.
veritysetup --hash-offset ${DATA_SIZE} \
    create vdevcfg ${DEVCFG} ${DEVCFG} ${ROOT_HASH} || exit 1
mount -t squashfs -o ro /dev/mapper/vdevcfg /mnt || exit 1

set +x
echo "Exit shell to unmount devcfg"
export PS1="devcfg-test: \$ "
bash --noprofile --norc -i
set -x

umount /mnt
veritysetup remove vdevcfg
