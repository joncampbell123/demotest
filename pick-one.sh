#!/bin/bash
x=$RANDOM
x=$((($x%1000)+1))

# NTS: For the time being, I want to test oldest first
x=1

suffix=
if [[ "$1" == "svn" ]]; then suffix="-svn"; fi

if [[ !( -f pick-one.cache ) ]]; then
    (./yet-to-test$suffix.pl | sort >pick-one.cache) || exit 1
fi

cat pick-one.cache | head -n $x | tail -n 1

