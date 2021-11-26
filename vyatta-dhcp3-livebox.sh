#!/usr/bin/env bash

OUT=$PWD/out
IMAGE=ynirk/wheezy-mips

mkdir -p $OUT

docker run --rm -t -v $PWD/scripts:/scripts -v $OUT:/out $IMAGE /scripts/vyatta-dhcp3-mips-deb.sh
