#!/usr/bin/env bash

set -e

echo "NitroOS ISO Build Starting..."

cd "$(dirname "$0")"

echo "Cleaning old build..."
sudo umount -Rl work 2>/dev/null || true
sudo rm -rf work out

echo "Building ISO..."
sudo mkarchiso -v .

echo "Build finished!"

echo "Output ISO:"
ls -lh ../relang/out/*.iso 2>/dev/null || echo "No ISO found!"

echo "Done."
