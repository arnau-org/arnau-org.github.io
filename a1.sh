#!/bin/sh
set -e

ISO_URL="https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-extended-3.23.3-x86_64.iso"

apk add --no-cache parted dosfstools e2fsprogs efibootmgr uniso wget

parted --script /dev/nvme0n1 mklabel gpt
parted --script --align=optimal /dev/nvme0n1 mkpart ESP fat32 1MiB 513MiB
parted --script --align=optimal /dev/nvme0n1 mkpart primary ext4 513MiB 4GiB  
parted --script --align=optimal /dev/nvme0n1 mkpart primary ext4 4GiB 100%
parted --script /dev/nvme0n1 set 1 esp on

modprobe vfat
modprobe ext4

mkfs.vfat -F32 /dev/nvme0n1p1
mkfs.ext4 -O ^has_journal,^64bit /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

if wget -O /root/alpine.iso "$ISO_URL"; then
  mount -t vfat /dev/nvme0n1p1 /mnt
  cd /mnt
  uniso < /root/alpine.iso
  sync
  cd ~ && umount /mnt
  efibootmgr --create --disk /dev/nvme0n1 --part 1 --label "Alpine Linux" --loader \\EFI\\boot\\bootx64.efi
fi
