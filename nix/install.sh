#!/usr/bin/env bash

set -euo pipefail

# Particionat
parted -s /dev/sda mklabel gpt
parted -s /dev/sda mkpart ESP fat32 1MiB 513MiB
parted -s /dev/sda set 1 esp on
parted -s /dev/sda mkpart root ext4 513MiB 100%

# Actualitzar la taula de particions al kernel
partprobe /dev/sda
udevadm settle

# Formateig
mkfs.fat -F 32 -n NIXBOOT /dev/sda1
mkfs.ext4 -F -L NIXROOT /dev/sda2

# Esperar que udev actualitzi els dispositius
udevadm settle

# Muntatge
mount /dev/disk/by-label/NIXROOT /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot

# Generació de configuració
nixos-generate-config --root /mnt

# Activar flakes a l'instal·lador
export NIX_CONFIG="experimental-features = nix-command flakes"

# Instal·lació
mv /mnt/etc/nixos/configuration.nix \
   /mnt/etc/nixos/configuration.nix.bak

for f in brave configuration desktop flake fonts home; do
    curl --output-dir /mnt/etc/nixos/ -O "https://arnau.org/nix/$f.nix"
done

#curl --output-dir /mnt/etc/nixos/ \
#     -O https://arnau.org/nix/brave.nix \
#     -O https://arnau.org/nix/configuration.nix \
#     -O https://arnau.org/nix/desktop.nix \
#     -O https://arnau.org/nix/flake.nix \
#     -O https://arnau.org/nix/fonts.nix \
#     -O https://arnau.org/nix/home.nix

nixos-install --root /mnt --flake /mnt/etc/nixos#argos

# Password
nixos-enter --root /mnt -c 'passwd antoni'

echo "Es pot reiniciar"
