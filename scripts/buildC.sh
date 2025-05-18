#!/bin/bash

SRC_FILE="../test.c"
OUT_BIN="../bin/blink.bin"
START_ADDR=0x8000

echo "[+] Compiling..."
cl65 --start-addr $START_ADDR --target none --cpu 6502 -o $OUT_BIN $SRC_FILE || exit 1

echo "[+] Flashing with minipro..."
minipro -p AT28C256 -w $OUT_BIN || exit 1

echo "[✓] Done!"
