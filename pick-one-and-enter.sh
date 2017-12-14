#!/bin/bash

emu="/usr/src/dosbox-x/src/dosbox-x --debug --showrt --showcycles"
gitcommit_sh="/usr/src/dosbox-x/git-commit-version.pl"

if [ -x $gitcommit_sh ]; then
    x=`dirname $gitcommit_sh`
    gitcommit=`cd $x && $gitcommit_sh`
    echo "DOSBox-X commit is $gitcommit"
    export gitcommit
fi

pass() {
    rm -f __FAIL__
    echo $gitcommit >__PASS__
    commit
}

commit() {
    git add *.conf *.map
    if [ -f __PASS__ ]; then git add __PASS__; fi
    if [ -f __FAIL__ ]; then git add __FAIL__; fi
    if [ -f __NOTES__ ]; then git add __NOTES__; fi
}

fail() {
    rm -f __PASS__
    echo $gitcommit >__FAIL__
    if [ -e __NOTES__ ]; then true; else echo 'Why the demo failed the test:' >__NOTES__; fi
    vi __NOTES__
    commit
}

run() {
    $emu
}

PS1="\s-\v demo test>> "

export PS1
export emu
export -f run
export -f pass
export -f fail
export -f commit

x=`./pick-one.sh`
if [ "$x" == "" ]; then echo "nothing picked"; exit 1; fi
echo "I picked: $x"

cp -vn dosbox-pentium.conf dosbox-template.conf || exit 1
cp -vn dosbox-template.conf "$x/dosbox.conf" || exit 1
cp -vn mapper-0.801.map "$x/mapper-0.801.map" || exit 1
cp -vn mapper-0.801.map "$x/mapper-0.81.map" || exit 1
cp -vn mapper-0.801.map "$x/mapper-0.82.map" || exit 1

(cd "$x" && echo "I entered the directory by running your shell again. Type 'exit' to exit out of it." && bash) || exit 1

