#!/bin/bash
x=$RANDOM
x=$((($x%1000)+1))

# NTS: For the time being, I want to test oldest first
x=1

suffix=
if [[ "$1" == "svn" ]]; then suffix="-svn"; fi

./yet-to-test$suffix.pl | sort | head -n $x | tail -n 1

