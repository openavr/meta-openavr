#!/bin/sh

set -x

PATH=/sbin:/bin:/usr/sbin:/usr/bin
export PATH

mkdir -p /proc
mkdir -p /sys

mount -t proc proc /proc
mount -t sysfs sysfs /sys

mkdir -p /dev
mount -t devtmpfs none /dev

mkdir -p /dev/pts
mount -t devpts devpts /dev/pts

# Find the SD card block device
if [ "$(cat /sys/block/mmcblk0/device/type)" == "SD" ]
then
    SD_BLK_DEV=mmcblk0
else
    SD_BLK_DEV=mmcblk1
fi

BOOT_DEV="/dev/${SD_BLK_DEV}p1"
RESC_DEV="/dev/${SD_BLK_DEV}p2"
CONF_DEV="/dev/${SD_BLK_DEV}p3"
DATA_DEV="/dev/${SD_BLK_DEV}p4"

mkdir -p /boot
mount -o ro -t vfat ${BOOT_DEV} /boot

# Device provisioning information goes in /config.
mkdir -p /config
mount -t ext4 -o rw ${CONF_DEV} /config

#
# TODO: Look for provisioning data. If not present, configure networking and
#       reach out to a provisioning server to get this node specific information.
#       This will require using something unique to this device (MAC, UUID,
#       Machine ID, etc).
#
#provision_device

#
# The /data partition data that persists across reboots and updates.
#
mkdir -p /data
mount -t ext4 -o rw ${DATA_DEV} /data

#
# Setup the rootfs.
# TODO: This needs the logic to deal with upgrades.
#
mkdir -p /rfs
#mount -o loop /boot/rootfs.squashfs-xz /rfs

# The Rescue rootfs partition
mount ${RESC_DEV} /rfs

PS1="OpenAVR: ${PS1}"
export PS1

#exec sh
echo "Exit shell to continue booting into full system."
sh

mount --move /proc /rfs/proc
mount --move /sys /rfs/sys
mount --move /dev /rfs/dev

mount --move /boot /rfs/boot
mount --move /config /rfs/config
mount --move /data /rfs/data

#
# Switch over to the real rootfs image and start up systemd
#
exec /sbin/switch_root /rfs /sbin/init