#!/bin/sh
# script extracts vWLC iso adds a few grub.cfg files
# adds lines to install_ucs install script to copy
# grub.cfg during install then recreates the iso
#
#
if [ -z $1 ]; then
    echo "no ISO argument"
    exit
fi
#
xorriso -osirrox on -indev $1 -extract / ./CDROM
#
mkdir -p ./CDROM/boot/grub
mkdir -p ./CDROM/grub
#
cp ./configs/boot/grub/grub.cfg ./CDROM/boot/grub/
cp ./configs/grub/grub.cfg ./CDROM/grub
#
mv ./CDROM/scripts/install_ucs ./CDROM/scripts/install_ucs.bak
sed -e '/"installed MBR"/a \
mkdir -p ${boot_dir}/boot/grub \
cp /mnt/cd/grub/grub.cfg ${boot_dir}/boot/grub
' < ./CDROM/scripts/install_ucs.bak > ./CDROM/scripts/install_ucs
chown 299636:smmsp ./CDROM/scripts/install_ucs
chmod 775 ./CDROM/scripts/install_ucs
#
xorriso -as mkisofs -r -V CDROM -J -J -joliet-long -cache-inodes -o bhyve_$1 ./CDROM
#
