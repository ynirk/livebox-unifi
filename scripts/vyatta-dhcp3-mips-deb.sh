#!/usr/bin/env bash
FIRMWARE_VERSION="4.4.34.5140612"
GPL_ARCHIVE="https://dl.ui.com/unifi/firmware/UGW3/$FIRMWARE_VERSION/GPL.UGW3.v$FIRMWARE_VERSION.tbz2"
DHCP_ARCHIVE="vyatta-dhcp3_4.1-ESV-R8-ubnt2.tgz"

echo "Downloading $GPL_ARCHIVE"
wget --timeout=300 -q $GPL_ARCHIVE -O /tmp/unifi-firmware.tbz2

echo "extracting $DHCP_ARCHIVE"
tar -xjpf /tmp/unifi-firmware.tbz2 -C /usr/local/src source/$DHCP_ARCHIVE

echo "unpacking $DHCP_ARCHIVE"
cd /usr/local/src/source
tar -xzpf vyatta-dhcp3_4.1-ESV-R8-ubnt2.tgz

echo "patching common/lpf.c"
patch common/lpf.c /scripts/vyatta-dhcp3-soprority.patch

echo "building deb targets"
dpkg-buildpackage -us -uc -amips

echo "copying binaries & deb packages"
cp /usr/local/src/vyatta-dhcp3*.deb /out
cp /usr/local/src/source/debian/vyatta-dhcp3-client/sbin/dhclient3 /out
