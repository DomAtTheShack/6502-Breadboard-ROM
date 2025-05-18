#!/usr/bin/env python3
import sys
import os
import shutil

if len(sys.argv) < 2:
	print("Usage: {} <file>".format(sys.argv[0]))
	sys.exit()

binaryfile = sys.argv[1]
emptyfile  = "/tmp/empty.bin"
size       = os.stat(binaryfile).st_size
limit      = (32 * 1024)
data       = bytearray([])

print("Filename: {}".format(binaryfile))
print("Original size: {} bytes".format(size))

with open(emptyfile, "wb") as f:
	f.seek(limit - (1 + size))
	f.write(b"\0")

with open(binaryfile, "rb") as a:
	data = data + bytearray(a.read())

with open(emptyfile, "rb") as b:
	data = data + bytearray(b.read())

data[0x7FFC] = 0x00
data[0x7FFD] = 0x80

with open(binaryfile, "wb") as dest:
	dest.write(data)

print("Final size: {} bytes".format(os.stat(binaryfile).st_size))