# NitroOS Live ISO Build

Simple instructions for building the **NitroOS** Arch-based Live ISO.

---

## Prerequisites

Make sure `archiso` is installed on your system:

```bash
sudo pacman -S --needed archiso
```

## Build the ISO

Run `mkarchiso` with `sudo` in this directory:

```bash
sudo mkarchiso -v -w work -o out .
```

- `-v`: Verbose output
- `-w work`: Temporary build/working directory
- `-o out`: Output directory for the final ISO image

Once finished, the generated ISO will be located in `out/`:

```bash
ls -lh out/*.iso
```

## Clean Build Files

To clean temporary build files and start fresh:

```bash
# Unmount any remaining chroot binds (if previous build was interrupted)
sudo umount -Rl work 2>/dev/null || true

# Remove working and output directories
sudo rm -rf work out
```

## Test the ISO with QEMU (Optional)

You can test the built ISO using `run_archiso`:

```bash
# BIOS mode
run_archiso -i out/nitroos-*.iso

# UEFI mode
run_archiso -u -i out/nitroos-*.iso
```
