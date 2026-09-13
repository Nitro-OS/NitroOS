#!/usr/bin/env bash

set -e

echo "NitroOS ISO Build Starting..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
PKGS_DIR="${ROOT_DIR}/pkgs"
PACMAN_CONF="${ROOT_DIR}/releng/pacman.conf"
PACMAN_CONF_BAK="${ROOT_DIR}/releng/pacman.conf.orig"

cd "${ROOT_DIR}"

cp "${PACMAN_CONF}" "${PACMAN_CONF_BAK}"
cleanup() {
    if [[ -f "${PACMAN_CONF_BAK}" ]]; then
        mv -f "${PACMAN_CONF_BAK}" "${PACMAN_CONF}"
    fi
}
trap cleanup EXIT INT TERM

echo "==> Cleaning old build..."
sudo umount -Rl scripts/work releng/work work 2>/dev/null || true
sudo rm -rf scripts/work releng/work releng/out out

echo "==> Checking local package repository..."
if ls "${PKGS_DIR}"/*.pkg.tar.zst 1> /dev/null 2>&1; then
    (cd "${PKGS_DIR}" && repo-add -R nitroos-pkgs.db.tar.gz *.pkg.tar.zst)
fi

echo "==> Configuring local pacman repository path dynamically..."
if grep -q "\[nitroos-pkgs\]" "${PACMAN_CONF}"; then
    sed -i "s|^Server = file://.*|Server = file://${PKGS_DIR}|" "${PACMAN_CONF}"
fi

echo "==> Building ISO..."
sudo mkarchiso -v -w releng/work -o releng/out ./releng

echo "==> Build finished!"
echo "==> Output ISO:"
ls -lh releng/out/*.iso 2>/dev/null || echo "No ISO found!"
