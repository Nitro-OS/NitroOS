#!/usr/bin/env bash

set -e

echo "NitroOS ISO Build Starting..."

cd "$(dirname "$0")"

echo "Cleaning old build..."
sudo umount -Rl work 2>/dev/null || true
sudo rm -rf ../releng/work ../relang/out

echo "Building ISO..."
sudo mkarchiso -v ../releng

echo "Build finished!"

echo "Output ISO:"
ls -lh ../releng/out/*.iso 2>/dev/null || echo "No ISO found!"

echo "Done."
