#!/bin/sh

# Instal·lar les eines necessàries
apk add parted efibootmgr wget

# Particionat del disc
parted --script /dev/sda mklabel gpt
parted --script --align=optimal /dev/sda mkpart ESP fat32 1MiB 4GiB
parted --script --align=optimal /dev/sda mkpart primary 4GiB 100%
parted --script /dev/sda set 1 boot on

# Formatació
mkfs.vfat /dev/sda1

# Obtenir l'enllaç de la versió més recent d'Alpine Linux
ISO_URL=$(wget -qO- https://dl-cdn.alpinelinux.org/alpine/ \
  | grep -oE '/alpine/v[0-9]+\.[0-9]+/releases/x86_64/alpine-extended-[0-9]+\.[0-9]+\.[0-9]+-x86_64\.iso' \
  | sort -V \
  | tail -n 1)

ISO_URL="https://dl-cdn.alpinelinux.org${ISO_URL}"

echo "Baixant la ISO des de: $ISO_URL"

# Baixar i preparar la ISO
if wget -O /root/alpine.iso "$ISO_URL"; then
  mount -t vfat /dev/sda1 /mnt
  cd /mnt
  uniso < /root/alpine.iso
  sync
  cd ~ && umount /mnt

  # Eliminar l'entrada "Alpine Linux" si existeix
  EXISTING_BOOT=$(efibootmgr | grep "Alpine Linux" | awk '{print $1}' | sed 's/^Boot//;s/\*//')
  if [ -n "$EXISTING_BOOT" ]; then
	echo "Eliminant l'entrada EFI existent: Boot$EXISTING_BOOT"
	efibootmgr -b "$EXISTING_BOOT" -B
  fi

  # Crear una nova entrada EFI
  efibootmgr --create --disk /dev/sda --part 1 --label "Alpine Linux" --loader /efi/boot/bootx64.efi
fi
