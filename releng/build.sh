#!/usr/bin/env bash

set -e

echo "NitroOS ISO Build Starting..."

# go to script directory (releng)
cd "$(dirname "$0")"

echo "Cleaning old build..."
sudo rm -rf work out

echo "Building ISO..."
sudo mkarchiso -v .

echo "Build finished!"

echo "Output ISO:"
ls -lh out/*.iso 2>/dev/null || echo "No ISO found!"

echo "Done."
