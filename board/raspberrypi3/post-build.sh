#!/bin/sh

set -u
set -e

# Add a console on tty1
if [ -e ${TARGET_DIR}/etc/inittab ]; then
    grep -qE '^tty1::' ${TARGET_DIR}/etc/inittab || \
	sed -i '/GENERIC_SERIAL/a\
tty1::respawn:/sbin/getty -L  tty1 0 vt100 # HDMI console' ${TARGET_DIR}/etc/inittab
fi

# Remove unused firmware files
UNNEEDED_FILES="brcmfmac43143.bin \
    brcmfmac43143-sdio.bin \
    brcmfmac43236b.bin \
    brcmfmac43241b0-sdio.bin \
    brcmfmac43241b4-sdio.bin \
    brcmfmac43241b5-sdio.bin \
    brcmfmac43242a.bin \
    brcmfmac43340-sdio.bin \
    brcmfmac43362-sdio.bin \
    brcmfmac43430a0-sdio.bin \
    brcmfmac43455-sdio.bin \
    brcmfmac43569.bin \
    brcmfmac43570-pcie.bin \
    brcmfmac43602-pcie.ap.bin \
    brcmfmac43602-pcie.bin"

if [ -d ${TARGET_DIR}/lib/firmware/brcm ]; then
    cd ${TARGET_DIR}/lib/firmware/brcm/
    for f in $UNNEEDED_FILES; do
        if [ -f $f ]; then
            rm $f
        fi
    done
fi
