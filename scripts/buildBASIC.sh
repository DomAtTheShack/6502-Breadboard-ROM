#!/bin/bash

cd ../BASIC

../BASIC/make.sh

echo "[+] Flashing with minipro..."
minipro -p AT28C256 -w ../bin/darwin.bin || exit 1