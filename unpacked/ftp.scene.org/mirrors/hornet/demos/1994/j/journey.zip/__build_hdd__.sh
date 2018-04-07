#!/bin/bash

# FIXME
hddimgdir=/mnt/main/emu/demotest
hddimg=$hddimgdir/msdos500hdd.20mb.vdi
prtofs=$((26*512))

rm -f __hdd__ || exit 1
qemu-img convert -O raw $hddimg __hdd__ || exit 1

# power
mcopy -i __hdd__@@$prtofs -b $hddimgdir/apm.exe ::apm.exe || exit 1

# DEMO
mmd -i __hdd__@@$prtofs demo || exit 1
mcopy -i __hdd__@@$prtofs -b *.* ::demo || exit 1

# configure
mdel -i __hdd__@@$prtofs ::autoexec.bat ::config.sys || exit 1
# config.sys
mcopy -i __hdd__@@$prtofs -t - ::config.sys <<_EOF
DEVICE=C:\DOS\HIMEM.SYS
DOS=HIGH,UMB
_EOF
# autoexec.bat
mcopy -i __hdd__@@$prtofs -t - ::autoexec.bat <<_EOF
@echo off
SET PATH=C:\DOS
SET ULTRASND=240,3,3,5,5
CD \DEMO
REM ------ RUN DEMO HERE
JOURNEY.EXE
ECHO ---- END OF DEMO ----
PAUSE
\\apm.exe off
_EOF

