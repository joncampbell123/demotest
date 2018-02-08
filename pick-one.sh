#!/bin/bash
x=$RANDOM
x=$(($x%1000))

suffix=
if [[ "$1" == "svn" ]]; then suffix="-svn"; fi

./yet-to-test$suffix.pl | head -n $x | tail -n 1

