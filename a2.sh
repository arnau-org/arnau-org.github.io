#!/bin/sh
set -e

apk add --no-cache blkid

ALPINE_UUID=$(blkid -s UUID -o value /dev/nvme0n1p2)
DATA___UUID=$(blkid -s UUID -o value /dev/nvme0n1p3)

cat > /etc/fstab <<EOF
UUID=${ALPINE_UUID} /media/alpine  ext4 ro,noatime          0 2
#UUID=${DATA___UUID} /data          ext4 ro,noatime         0 2
EOF
cat /etc/fstab

mkdir -p /media/alpine /data
mount -a

echo "Executar setup-alpine"
