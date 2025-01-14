#!/bin/sh

# Instal·la les eines necessàries
apk add --no-cache parted efibootmgr wget

# Crea la taula de particions i prepara les particions
parted --script /dev/sda mklabel gpt
parted --script --align=optimal /dev/sda mkpart ESP fat32 1MiB 4GiB
parted --script --align=optimal /dev/sda mkpart primary 4GiB 100%
parted --script /dev/sda set 1 boot on

# Dona format a la partició d'EFI
mkfs.vfat /dev/sda1

# Elimina totes les entrades EFI existents
echo "Eliminant totes les entrades EFI existents..."
for bootnum in $(efibootmgr | grep '^Boot' | awk '{print $1}' | grep -o '[0-9A-F]\+'); do
  efibootmgr --delete-bootnum --bootnum "$bootnum"
done

# Determina l'última versió estable
BASE_URL="https://dl-cdn.alpinelinux.org/alpine/latest-stable/releases/x86_64"
ISO_NAME=$(wget -qO- "$BASE_URL/" | grep -o 'alpine-extended-[0-9.]*-x86_64.iso' | tail -n1)

if [ -z "$ISO_NAME" ]; then
  echo "No s'ha pogut determinar l'última versió estable."
  exit 1
fi

# Baixa la imatge ISO
if wget "$BASE_URL/$ISO_NAME" -O /tmp/alpine-extended.iso; then
  # Munta la partició EFI
  mount -t vfat /dev/sda1 /mnt

  # Extreu el contingut de la ISO
  cd /mnt
  uniso < /tmp/alpine-extended.iso
  sync

  # Desa els canvis i desmunta
  cd ~ && umount /mnt

  # Crea l'entrada EFI
  efibootmgr --create --disk /dev/sda --part 1 --label "Alpine Linux" --loader /efi/boot/bootx64.efi
else
  echo "Error en baixar la imatge ISO. Revisa la connexió o l'adreça proporcionada."
  exit 1
fi

echo "El procés s'ha completat amb èxit."
