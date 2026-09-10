#!/usr/bin/env bash

set -e

echo "NitroOS ISO Build Starting..."

cd "$(dirname "$0")/.."

echo "==> Cleaning old build..."
sudo umount -Rl scripts/work releng/work work 2>/dev/null || true
sudo rm -rf scripts/work releng/work releng/out out

echo "==> Checking local package repository..."
if ls pkgs/*.pkg.tar.zst 1> /dev/null 2>&1; then
    (cd pkgs && repo-add -R nitroos-pkgs.db.tar.gz *.pkg.tar.zst)
fi

echo "==> Building ISO..."
sudo mkarchiso -v -w releng/work -o releng/out ./releng

echo "==> Build finished!"
echo "==> Output ISO:"
ls -lh releng/out/*.iso 2>/dev/null || echo "No ISO found!"
