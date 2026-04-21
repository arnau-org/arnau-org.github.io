#!/bin/sh
set -e

apk add --no-cache parted dosfstools e2fsprogs util-linux efibootmgr

wipefs --all /dev/nvme0n1

parted --script /dev/nvme0n1 mklabel gpt
parted --script --align=optimal /dev/nvme0n1 mkpart ESP fat32 1MiB 2GiB
parted --script --align=optimal /dev/nvme0n1 mkpart primary ext4 2GiB 6GiB  
parted --script --align=optimal /dev/nvme0n1 mkpart primary ext4 6GiB 100%
parted --script /dev/nvme0n1 set 1 esp on

modprobe vfat
modprobe ext4

mkfs.vfat -F32 /dev/nvme0n1p1
mkfs.ext4 -O ^has_journal /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

mkdir -p /media/nvme0n1p1
mount -t vfat /dev/nvme0n1p1 /media/nvme0n1p1
cp -aT /media/sda /media/nvme0n1p1
sync
umount /media/nvme0n1p1

# Ara no cal car ja està configurat de l'anterior vegada
#efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Alpine Linux" --loader \\EFI\\boot\\bootx64.efi
