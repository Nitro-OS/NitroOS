#!/usr/bin/env bash

cd "$(dirname "$0")/.."
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -m 4096 \
  -vga virtio \
  -display gtk,gl=on \
  -cdrom releng/out/*.iso \
  -boot d
