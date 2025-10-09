# Speed Cluster Drive Mapping Utility

## Overview

This repository provides scripts to map the Speed scratch storage directory `\\filer-speed.encs.concordia.ca\speed_scratch` across different operating systems.

These scripts allow you to conveniently mount  `/speed-scratch` folder from personal or university computers—whether on campus or connected remotely via VPN.

## Prerequisites

- Encure you have [access](https://nag-devops.github.io/speed-hpc/#requesting-access) to the HPC (Speed) cluster.
- VPN is required if off campus

## Windows Instructions

### Files:
- Speed_Scratch_Windows_Map.bat
- Speed_Scratch_Windows_Map.ps1

### Instructions
- Download both files and place them in the same folder (for example: `Downloads\SpeedMap`).
- Double-click `Speed_Scratch_Windows_Map.bat`.
- When prompted, enter your ENCS username and password.
- The script will:
    - Disconnect any existing Y: mapping
    - Map `\\filer-speed.encs.concordia.ca\speed_scratch`
    - Open File Explorer showing the new drive

**NOTE:** If you need to change the mapping to a different letter, you can do so by edditing the `Speed_Scratch_Windows_Map.ps1` file and change the following variable:
```
$DriveLetter = 'Y:'  # <- Change this if needed
```

## Linux and macOS Instructions
coming soon...