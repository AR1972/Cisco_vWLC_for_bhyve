========================================================================
========================================================================

a few scripts to make installing and running Cisco's wireless lan
controller on FreeBSD a little less painful.

========================================================================
install packages:
========================================================================

pkg install grub2-bhyve xorriso

========================================================================
setup FreeBSD:
========================================================================
------------------------------------------------------------------------
install nullmodem driver:
------------------------------------------------------------------------
kldload nmdm

------------------------------------------------------------------------
setup network:
------------------------------------------------------------------------
create a bridge interface and add your network interface, replace
example_if with the interface you are using to conect to your network

ifconfig bridge create
ifconfig bridge0 addm example_if

------------------------------------------------------------------------
create zvol:
------------------------------------------------------------------------
zfs create -V 8G zroot/sda

========================================================================
download Cisco vWLC:
========================================================================

https://software.cisco.com/download/home/284464214/type/280926587/release/8.2.170.0

========================================================================
prepare install media:
========================================================================

./fix_boot.sh MFG_CTVM_8_2_170_0.iso

========================================================================
install Cisco vWLC:
========================================================================

edit install_vm.sh for your usecase
run install_vm.sh

install process will begin and needs no user interaction and will
shutdown the VM once installation is complete.

========================================================================
run Cisco vWLC:
========================================================================

edit boot_vm.sh for your usecase
restart the VM with boot_vm.sh, once the VM begins to boot, connect to
the VM with a terminal program like cu.
 
cu -l /dev/nmdm99

once the VM has finished booting, the vWLC will begin an inital 
setup, the managment inteface is the interface with the web interface
and how the AP's will get their configuration. The AP's look for
CISCO-CAPWAP-CONTROLLER to download their firmware and confg files,
CISCO-CAPWAP-CONTROLLER must be added to your DNS and point to your
newly installed vWLC.

======================================================================== 
refrences:
========================================================================

https://tetragir.com/freebsd/bhyve/cisco-vwlc-on-freebsd-bhyve.html
https://docs.freebsd.org/en/books/handbook/zfs/
https://docs.freebsd.org/en/books/handbook/advanced-networking/

========================================================================
========================================================================
