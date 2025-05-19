#!/bin/bash
# Simplified build script for custom 6502 system

# Set up error handling
set -e  # Exit on error

# Path to cc65 libs - modify as needed
CC65_LIB=${CC65_LIB:-/usr/local/lib/cc65/lib}
CC65_INC=${CC65_INC:-/usr/local/share/cc65/include}

# Create output name
OUTNAME=custom6502

# Clean up previous files
echo "Cleaning previous build..."
rm -f *.o $OUTNAME.bin $OUTNAME.rom

# Compile startup code
echo "Compiling crt0.s..."
ca65 crt0.s -o crt0.o || { echo "Failed to compile crt0.s"; exit 1; }

# Compile IO code
echo "Compiling io.c..."
cc65 -t none -O io.c -o io.s || { echo "Failed to compile io.c"; exit 1; }
ca65 io.s -o io.o || { echo "Failed to assemble io.s"; exit 1; }

# Compile main program
echo "Compiling main.c..."
cc65 -t none -O main.c -o main.s || { echo "Failed to compile main.c"; exit 1; }
ca65 main.s -o main.o || { echo "Failed to assemble main.s"; exit 1; }

# Link everything
echo "Linking..."
ld65 -C custom6502.cfg -o $OUTNAME.bin crt0.o io.o main.o $CC65_LIB/none.lib
if [ $? -eq 0 ]; then
    echo "Build successful! Created $OUTNAME.bin"

    # Convert to raw binary for ROM programmer if objcopy is available
    if command -v objcopy &> /dev/null; then
        objcopy -O binary $OUTNAME.bin $OUTNAME.rom
        echo "Created ROM image: $OUTNAME.rom"
    fi

    # Show file size
    filesize=$(stat -c %s "$OUTNAME.bin" 2>/dev/null || stat -f %z "$OUTNAME.bin")
    echo "Binary size: $filesize bytes"

    # Optional: print out sections using objdump if available
    if command -v objdump &> /dev/null; then
        echo -e "\nSection information:"
        objdump -h $OUTNAME.bin
    fi
else
    echo "Build failed!"
    exit 1
fi