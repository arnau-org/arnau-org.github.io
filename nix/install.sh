
# Particionat
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda -- set 1 esp on
parted /dev/sda -- mkpart root ext4 512MiB 100%

# Formateig
mkfs.fat -F 32 /dev/sda1
fatlabel /dev/sda1 NIXBOOT
mkfs.ext4 /dev/sda2 -L NIXROOT

# Muntatge
mount /dev/disk/by-label/NIXROOT /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/NIXBOOT /mnt/boot

# Generació de configuració
nixos-generate-config --root /mnt

# Activar flakes a l'instal·lador
export NIX_CONFIG="experimental-features = nix-command flakes"

# Instal·lació
mv /mnt/etc/nixos/configuration.nix /mnt/etc/nixos/configuration.nix.bak

curl --output-dir /mnt/etc/nixos/ \
     -O https://arnau.org/nix/brave.nix \
     -O https://arnau.org/nix/configuration.nix \
     -O https://arnau.org/nix/desktop.nix \
     -O https://arnau.org/nix/flake.nix \
     -O https://arnau.org/nix/fonts.nix \
     -O https://arnau.org/nix/home.nix

nixos-install --root /mnt --flake /mnt/etc/nixos#argos

# Password
nixos-enter --root /mnt -c 'passwd antoni'

echo "Es pot reiniciar"