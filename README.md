# NitroOS Live ISO

Simple scripts to build and test the **NitroOS** Live ISO.

## 1. Prerequisites

```bash
sudo pacman -S --needed archiso qemu-desktop
```

## 2. Build ISO

Run the build script:

```bash
./scripts/build.sh
```

The output ISO will be saved to `releng/out/`.

## 3. Test ISO (QEMU)

Run the ISO in a virtual machine:

- **BIOS mode:**
  ```bash
  ./scripts/run.sh
  ```

- **UEFI mode:**
  ```bash
  ./scripts/run-uefi.sh
  ```
