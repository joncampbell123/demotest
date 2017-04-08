#!/bin/bash
x=$RANDOM
x=$(($x%1000))
./yet-to-test.pl | head -n $x | tail -n 1

