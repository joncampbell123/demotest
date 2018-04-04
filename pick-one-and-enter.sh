#!/bin/bash

what=
pext=
filesuffix=

if [[ "$1" == "svn" ]]; then what=svn; pext=" svn"; filesuffix="_SVN"; fi
if [[ "$1" == "xdos" ]]; then what=xdos; pext=" xdos"; filesuffix="_XDOS"; fi

pick=

if [[ -n "$2" ]]; then
    pick="$2"
    if [[ !( -d "$pick" ) ]]; then echo No such $pick; exit 1; fi
fi

if [[ "$what" == "svn" ]]; then
    if [ -x /home/jon/src/dosbox-svn/src/dosbox-svn ]; then
        dosbox_root="/home/jon/src/dosbox-svn"
    else
        dosbox_root="/usr/src/dosbox-svn"
    fi

    emu="$dosbox_root/src/dosbox --debug"
    gitcommit_sh="`pwd`/dosbox-svn-git-commit-version.pl $dosbox_root"
    gitcommit=`cd $x && $gitcommit_sh`
    echo "DOSBox-SVN commit is $gitcommit"
    export gitcommit
else
    if [ -x /home/jon/src/dosbox-x/src/dosbox-x ]; then
        emu="/home/jon/src/dosbox-x/src/dosbox-x --debug --showrt --showcycles"
	gitcommit_sh="/home/jon/src/dosbox-x/git-commit-version.pl"
    else
        emu="/usr/src/dosbox-x/src/dosbox-x --debug --showrt --showcycles"
	gitcommit_sh="/usr/src/dosbox-x/git-commit-version.pl"
    fi

    if [ -x $gitcommit_sh ]; then
        x=`dirname $gitcommit_sh`
        gitcommit=`cd $x && $gitcommit_sh`
        echo "DOSBox-X commit is $gitcommit"
        export gitcommit
    fi
fi

if [[ "$what" == "xdos" ]]; then
    emu+=" --conf dosbox-xdos.conf"
fi

export filesuffix

windows() {
    echo $gitcommit >"__WINDOWS__"
    echo $gitcommit >"__WINDOWS_SVN__"
    commit
}

pass() {
    rm -f "__FAIL"$filesuffix"__"
    echo $gitcommit >"__PASS"$filesuffix"__"
    commit
}

commit() {
    git add *.conf *.map

    if [ -f "__build_hdd__.sh" ]; then git add "__build_hdd__.sh"; fi

    if [ -f "__PASS"$filesuffix"__" ]; then git add "__PASS"$filesuffix"__"; fi
    if [ -f "__FAIL"$filesuffix"__" ]; then git add "__FAIL"$filesuffix"__"; fi
    if [ -f "__NOTES"$filesuffix"__" ]; then git add "__NOTES"$filesuffix"__"; fi

    if [ -f "__WINDOWS__" ]; then git add "__WINDOWS__"; fi
    if [ -f "__WINDOWS_SVN__" ]; then git add "__WINDOWS_SVN__"; fi
}

fail() {
    rm -f "__PASS"$filesuffix"__"
    echo $gitcommit >"__FAIL"$filesuffix"__"
    if [ -e "__NOTES"$filesuffix"__" ]; then true; else echo 'Why the demo failed the test:' >"__NOTES"$filesuffix"__"; fi
    vi "__NOTES"$filesuffix"__"
    commit
}

run() {
    $emu
}

download() {
    $downld
}

PS1="\s-\v demo test$pext>> "

export PS1
export emu
export downld
export -f run
export -f pass
export -f fail
export -f commit
export -f windows
export -f download

if [ -n "$pick" ]; then
    x="$pick"
else
    x=`./pick-one.sh $what`
fi

if [ "$x" == "" ]; then echo "nothing picked"; exit 1; fi
echo "I picked: $x"

y=`echo "$x" | grep -E '\/(19[8][0-9]|199[0-2])\/'`
if [ -n "$y" ]; then
    cp -v dosbox-386.conf dosbox-template.conf || exit 1
else
    cp -v dosbox-pentium.conf dosbox-template.conf || exit 1
fi


if [[ "$what" == "xdos" ]]; then
    cp -vn dosbox-template.conf "$x/dosbox.conf" || exit 1
    if [[ !( -f "$x/dosbox-xdos.conf" ) ]]; then
        cat "$x/dosbox.conf" dosbox-xdos.example.conf >>"$x/dosbox-xdos.conf" || exit 1
    fi
    cp -vn xdos-__build_hdd__.example.sh "$x/__build_hdd__.sh" || exit 1
else
    cp -vn dosbox-template.conf "$x/dosbox.conf" || exit 1
fi

cp -vn mapper-0.801.map "$x/mapper-0.801.map" || exit 1
cp -vn mapper-0.801.map "$x/mapper-0.81.map" || exit 1
cp -vn mapper-0.801.map "$x/mapper-0.82.map" || exit 1
cp -vn mapper-0.801.map "$x/mapper-0.82.1.map" || exit 1
cp -vn mapper-0.801.map "$x/mapper-0.82.2.map" || exit 1
cp -vn mapper-0.801.map "$x/mapper-0.82.3.map" || exit 1
cp -vn mapper-0.801.map "$x/mapper-0.82.4.map" || exit 1
cp -vn mapper-SVN.map "$x/mapper-SVN.map" || exit 1

downld="`pwd`/demo-download.pl"

(cd "$x" && echo "I entered the directory by running your shell again. Type 'exit' to exit out of it." && bash) || exit 1

