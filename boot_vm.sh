#!/bin/sh
# srcipt to assist booting Cisco vWLC
# on a bhyve virtual machine, edit the
# ZVOL path to point to the zvol that
# was created for install
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
# netwrok taps, edit as needed
TAP0=tap100
TAP1=tap101
#
# virtual serial port, can be stdio
COM=/dev/nmdm99A
#
#
IFCONFIG=/sbin/ifconfig
GREP=/usr/bin/grep
BHYVECTL=/usr/sbin/bhyvectl
SYSCTL=/sbin/sysctl
GRUBBHYVE=/usr/local/sbin/grub-bhyve
BHYVE=/usr/sbin/bhyve
ROOT=hd0,msdos1
#
if [ -e /dev/vmm/$VM ]; then
    $BHYVECTL --vm=$VM --destroy
    $IFCONFIG $TAP0 destroy
    $IFCONFIG $TAP1 destroy
fi
#
sleep 2
#
while ! $IFCONFIG -l | $GREP bridge0 >> /dev/null; do
    sleep 60
done
#
$IFCONFIG $TAP0 create
$IFCONFIG $TAP1 create
$SYSCTL net.link.tap.up_on_open=1
$IFCONFIG bridge0 addm $TAP1
#
echo \(hd0\)$ZVOL > /var/tmp/device.map
#
$GRUBBHYVE -m /var/tmp/device.map -r $ROOT -M 2048 $VM
#
$BHYVE -A -H -P \
-s 0:0,hostbridge \
-s 1:0,lpc \
-s 2:0,ahci-hd,$ZVOL \
-s 3:0,virtio-net,$TAP0 \
-s 4:0,virtio-net,$TAP1 \
-l com1,$COM \
-c 1 \
-m 2048M \
$VM &
#
