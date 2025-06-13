#!/bin/sh

DISK="/dev/sdX"
ESP="${DISK}1"
EXT="${DISK}2"

apk add --no-cache parted efibootmgr wget e2fsprogs

parted --script "$DISK" mklabel gpt
parted --script --align=optimal "$DISK" mkpart ESP fat32 1MiB 4GiB
parted --script "$DISK" set 1 esp on
parted --script --align=optimal "$DISK" mkpart primary ext4 4GiB 100%

modprobe ext4

mkfs.vfat -F "$ESP"
mkfs.ext4 "$EXT"

wget https://dl-cdn.alpinelinux.org/alpine/v3.22/releases/x86_64/alpine-extended-3.22.0-x86_64.iso
mount -t vfat "$ESP" /mnt
cd /mnt
uniso < /root/alpine-extended-3.22.0-x86_64.iso
sync
cd ~ && umount /mnt

efibootmgr --create --disk "$DISK" --part 1 --label "Alpine Linux" --loader /efi/boot/bootx64.efi
