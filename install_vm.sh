#!/bin/sh
# script assists installing Cisco vWLC to
# a bhyve virtual machine, create a 8G
# zvol for the virtual macine and edit
# ZVOL path below.
#
#
# edit as needed
#
# virtual machine name
VM=99_vWLC
#
# path to a 8G zvol
ZVOL=/dev/zvol/zroot/sda
#
# path to install media
CD=$PWD/bhyve_MFG_CTVM_8_2_170_0.iso
#
# netwrok taps, edit as needed
TAP0=tap100
TAP1=tap101
#
# virtual serial port, can be stdio
COM=stdio
#
#
IFCONFIG=/sbin/ifconfig
GREP=/usr/bin/grep
BHYVECTL=/usr/sbin/bhyvectl
SYSCTL=/sbin/sysctl
GRUBBHYVE=/usr/local/sbin/grub-bhyve
BHYVE=/usr/sbin/bhyve
ROOT=cd0
#
#
if [ -e /dev/vmm/$VM ]; then
    $BHYVECTL --vm=$VM --destroy
    $IFCONFIG $TAP0 destroy
    $IFCONFIG $TAP1 destroy
fi
#
sleep 2
#
echo \(hd0\)$ZVOL > $PWD/device.map
echo \(cd0\)$CD >> $PWD/device.map
#
$GRUBBHYVE -m $PWD/device.map -r $ROOT -M 2048 $VM 
#
$BHYVE -A -H -P \
-s 0:0,hostbridge \
-s 1:0,lpc \
-s 2:0,ahci-hd,$ZVOL \
-s 3:0,ahci-cd,$CD \
-l com1,$COM \
-c 1 \
-m 2048M \
$VM
