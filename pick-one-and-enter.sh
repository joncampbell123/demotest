#!/bin/bash
x=`./pick-one.sh`
if [ "$x" == "" ]; then echo "nothing picked"; exit 1; fi
echo "I picked: $x"

cp -vn dosbox-pentium.conf dosbox-template.conf || exit 1
cp -vn dosbox-template.conf "$x/dosbox.conf" || exit 1
cp -vn mapper-0.801.map "$x/mapper-0.801.map" || exit 1

(cd "$x" && echo "I entered the directory by running your shell again. Type 'exit' to exit out of it." && bash) || exit 1

