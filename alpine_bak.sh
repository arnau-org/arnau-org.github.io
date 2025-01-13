#!/bin/sh

apk add parted efibootmgr

parted --script /dev/sda mklabel gpt
parted --script --align=optimal /dev/sda mkpart ESP fat32 1MiB 2GiB
parted --script --align=optimal /dev/sda mkpart primary 2GiB 100%
parted --script /dev/sda set 1 boot on

mkfs.vfat /dev/sda1

if wget https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/x86_64/alpine-extended-3.21.0-x86_64.iso; then
  mount -t vfat /dev/sda1 /mnt
  cd /mnt
  uniso < /root/alpine-extended-3.21.0-x86_64.iso
  sync
  cd ~ && umount /mnt
  efibootmgr --create --disk /dev/sda --part 1 --label "Alpine Linux" --loader /efi/boot/bootx64.efi
fi
