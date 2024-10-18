#!/bin/sh

apk add parted xfsprogs efibootmgr

sleep 5

parted --script /dev/sda mklabel gpt
parted --script --align=optimal /dev/sda mkpart ESP fat32 1MiB 4GiB
parted --script --align=optimal /dev/sda mkpart primary 4GiB 100%
parted --script /dev/sda set 1 boot on

sleep 5

mkfs.vfat /dev/sda1
mkfs.xfs /dev/sda2

sleep 5

wget https://dl-cdn.alpinelinux.org/alpine/v3.20/releases/x86_64/alpine-extended-3.20.3-x86_64.iso

sleep 5

mount -t vfat /dev/sda1 /mnt
cd /mnt
uniso < /root/alpine-extended-3.20.3-x86_64.iso

sleep 5

sync

sleep 5

cd ~ && umount /mnt

efibootmgr --create --disk /dev/sda --part 1 --label "Alpine Linux" --loader /efi/boot/bootx64.efi
