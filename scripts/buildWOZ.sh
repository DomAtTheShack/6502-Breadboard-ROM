#!/bin/bash
cmake -S . -B build
cmake --build build --target buildWozClean
exit 0

