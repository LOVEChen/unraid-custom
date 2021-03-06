#!/bin/bash

mkdir -p /boot/unraid-custom/packages
mkdir -p /tmp/bzroot

cd /boot/unraid-custom/packages

# deps.
[ ! -f "cpio-2.9-i486-2.txz" ] && wget http://slackware.cs.utah.edu/pub/slackware/slackware-13.1/slackware/a/cpio-2.9-i486-2.txz
[ ! -x "/bin/cpio" ] && installpkg cpio-2.9-i486-2.txz

# extract.
cd /tmp/bzroot
zcat /boot/bzroot | cpio -i -d -H newc --no-absolute-filenames
