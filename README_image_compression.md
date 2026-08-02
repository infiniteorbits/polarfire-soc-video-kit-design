# README - Image Compression

This document explains the **image compression** part of the project and how
to launch the related designs.

## Purpose

This section of the repository is used to generate and test JPEG-based designs
for the PolarFire SoC Video Kit.

## What the project contains

### 1. JPEG Write

- Script: `MPFS_VIDEO_KIT_JPEG_WRITE.tcl`
- Generated project: `VKPFSOC_JPEG_WRITE`

This design writes compressed image data to DDR memory.

### 2. JPEG Write / Read

- Script: `MPFS_VIDEO_KIT_JPEG_WRITE_READ.tcl`
- Generated project: `VKPFSOC_JPEG_WRITE_READ`

This design writes and reads image data back to verify the end-to-end flow.

## Important files

- `script_support/constraints/JPEG_WRITE/`
- `script_support/constraints/JPEG_WRITE_READ/`
- `script_support/MSS_VIDEO_KIT/JPEG_WRITE/`
- `script_support/MSS_VIDEO_KIT/JPEG_WRITE_READ/`
- `script_support/dtso_overlay/JPEG_WRITE/`
- `script_support/dtso_overlay/JPEG_WRITE_READ/`

## Requirements

- Libero SoC Design Suite
- The version used by these scripts: **2025.1**
- `wget` to download HSS
- `python`, `cpp`, and `dtc` for SPI flash overlays
- WSL is recommended on Windows for overlay generation

## How to run the project

### From Libero

1. Open Libero SoC 2025.1.
2. Load this repository.
3. Open **Execute Script** (`Ctrl + U`).
4. Run the desired script:

```tcl
MPFS_VIDEO_KIT_JPEG_WRITE.tcl
```

or

```tcl
MPFS_VIDEO_KIT_JPEG_WRITE_READ.tcl
```

## Useful arguments

You can add these arguments to the script:

- `SYNTHESIZE`: run synthesis
- `PLACEROUTE`: run synthesis + place and route
- `VERIFY_TIMING`: run timing verification
- `GENERATE_PROGRAMMING_DATA`: generate programming files
- `PROGRAM`: run the full flow and program the board
- `EXPORT_FPE`: export a FlashPro Express file
- `HSS_UPDATE`: download and add the HSS binary
- `SPIFLASH_DATA`: generate SPI flash data for the DTBO overlay

## Example

```tcl
SYNTHESIZE PLACEROUTE VERIFY_TIMING HSS_UPDATE SPIFLASH_DATA EXPORT_FPE
```

## After generation

Once the project is generated, you can:

- continue the flow in Libero
- program the board
- export the project if needed

## Note

This README complements the Microchip documentation. It focuses on the
**image compression** part of the repository.
