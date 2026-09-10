#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PKGS_DIR="${ROOT_DIR}/pkgs"

echo "==> Building local NitroOS package repository..."
mkdir -p "${PKGS_DIR}"

if ! ls "${PKGS_DIR}"/ckbcomp-*.pkg.tar.zst 1> /dev/null 2>&1; then
    echo "==> Building ckbcomp..."
    cd "${PKGS_DIR}"
    [[ -d ckbcomp ]] || git clone https://aur.archlinux.org/ckbcomp.git
    cd ckbcomp
    makepkg -sc --noconfirm
    cp ckbcomp-*.pkg.tar.zst "${PKGS_DIR}/"
fi

if ! ls "${PKGS_DIR}"/calamares-*.pkg.tar.zst 1> /dev/null 2>&1; then
    echo "==> Building calamares..."
    cd "${PKGS_DIR}"
    [[ -d calamares ]] || git clone https://aur.archlinux.org/calamares.git
    cd calamares
    makepkg -sc --noconfirm
    cp calamares-*.pkg.tar.zst "${PKGS_DIR}/"
fi

echo "==> Generating repository database..."
cd "${PKGS_DIR}"
rm -f nitroos-pkgs.db* nitroos-pkgs.files*
repo-add nitroos-pkgs.db.tar.gz *.pkg.tar.zst

echo "==> Local package repository ready!"