#!/bin/bash

# Usage: ./replace_eater.sh /path/to/folder

if [ -z "$1" ]; then
  echo "Usage: $0 /path/to/folder"
  exit 1
fi

FOLDER="$1"

# Replace 'eater' with 'darwin' in all files except .bin
find "$FOLDER" -type f ! -name '*.bin' | while read -r file; do
  # Replace inside file contents
  sed -i 's/darwin/eater/g' "$file"
done

# Rename any files that include 'def_eater' in their name
find "$FOLDER" -depth -type f -name '*def_eater*' | while read -r file; do
  dir=$(dirname "$file")
  base=$(basename "$file")
  newbase=${base//def_eater/def_darwin}
  mv "$file" "$dir/$newbase"
done

echo "Text replacement and file renaming complete."
