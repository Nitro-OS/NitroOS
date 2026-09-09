#!/usr/bin/env bash
qemu-system-x86_64 \
  -enable-kvm \
  -cpu host \
  -smp 4 \
  -m 4096 \
  -vga virtio \
  -display gtk,gl=on \
  -bios /usr/share/ovmf/x64/OVMF.4m.fd \
  -cdrom ../relang/out/*.iso \
  -boot d
