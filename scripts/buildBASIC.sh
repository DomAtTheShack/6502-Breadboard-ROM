#!/bin/bash

cd ./BASIC

./make.sh || exit 1

cd ..

echo "[+] Flashing with minipro..."
minipro -p AT28C256 -w ./bin/darwin.bin || exit 1