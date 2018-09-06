#!/bin/bash

# FIXME
hddimgdir=/mnt/main/emu/demotest
hddimg=$hddimgdir/msdos622hdd.16mb.vdi
prtofs=$((21*512))

rm -f __hdd__ || exit 1
qemu-img convert -O raw $hddimg __hdd__ || exit 1

# DEMO
mmd -i __hdd__@@$prtofs demo || exit 1
mcopy -i __hdd__@@$prtofs -b *.EXE ::demo || exit 1

# mouse
mcopy -i __hdd__@@$prtofs -b $hddimgdir/ctmouse.exe ::ctmouse.exe || exit 1

# configure
mdel -i __hdd__@@$prtofs ::autoexec.bat ::config.sys || exit 1
# config.sys
mcopy -i __hdd__@@$prtofs -t - ::config.sys <<_EOF
DEVICE=C:\DOS\HIMEM.SYS
DEVICE=C:\DOS\EMM386.EXE
DOS=HIGH,UMB
_EOF
# autoexec.bat
mcopy -i __hdd__@@$prtofs -t - ::autoexec.bat <<_EOF
@echo off
SET PATH=C:\DOS
SET BLASTER=A220 I7 D1
SET ULTRASND=240,3,3,5,5
\CTMOUSE.EXE
CD \DEMO
ITSDEMO.EXE
ECHO ---- END OF DEMO ----
_EOF

