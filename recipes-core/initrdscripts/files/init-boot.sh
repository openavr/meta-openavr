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

mkdir -p /boot
mkdir -p /rfs

mount -o ro -t vfat /dev/mmcblk0p1 /boot
mount -o loop /boot/rootfs.squashfs-xz /rfs

PS1="OpenAVR: ${PS1}"
export PS1

#exec sh
echo "Exit shell to continue booting into full system."
sh

mount --move /proc /rfs/proc
mount --move /sys /rfs/sys
mount --move /dev /rfs/dev

mount --move /boot /rfs/boot

#
# Switch over to the real rootfs image and start up systemd
#
exec /sbin/switch_root /rfs /sbin/init
