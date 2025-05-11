#!/bin/bash
cmake -S . -B build
cmake --build build --target flashR
exit 0
