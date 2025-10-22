# Speed Cluster Drive Mapping Utility

## Overview

This repository provides scripts to map the Speed scratch storage directory `\\filer-speed.encs.concordia.ca\speed_scratch` across different operating systems.

These scripts allow you to conveniently mount  `/speed-scratch` folder from personal or university computers—whether on campus or connected remotely via VPN.

## Prerequisites

- Encure you have [access](https://nag-devops.github.io/speed-hpc/#requesting-access) to the HPC (Speed) cluster.
- VPN is required if off campus

## Windows Instructions

### Files:
- `speed-scratch-Windows-map.bat`
- `speed-scratch-Windows-map.ps1`

### Instructions
- Download both files and place them in the same folder (for example: `Downloads\SpeedMap`).
- Double-click `speed-scratch-Windows-map.bat`.
- When prompted, enter your ENCS username and password.
- The script will:
    - Disconnect any existing Y: mapping
    - Map `\\filer-speed.encs.concordia.ca\speed_scratch`
    - Open File Explorer showing the new drive

**NOTE:** To change the mapped drive letter, edit the following line in `speed-scratch-Windows-map.ps1` file:
```
$DriveLetter = 'Y:'  # <- Change this if needed
```

## MacOS Instructions

### Files:
- Speed_Scratch_MacOS_Map.sh

### Instructions
- Download the file to your `Downloads` folder
- Open Terminal and navigate to that folder
- Run the script
```
./Speed_Scratch_MacOS_Map.sh
```
- The script will:
    - Unmount the Share if already mounted
    - Mount `filer-speed.encs.concordia.ca/speed_scratch` to `/Users/<YourUser>/Speed_Scratch`
    - Open Finder showing the network drive

## Linux Instructions

### Instructions for Manual Mount via File Manager
- Open your **Files** (File Manager) application.
- In the sidebar, select **Other Locations** (or Connect to Server on some desktops).
- At the bottom, under “Connect to Server”, enter: `smb://filer-speed.encs.concordia.ca/speed_scratch`
- When prompted:
  - **Connect As**: Registered User
  - **Username**: your ENCS username
  - **Domain**: ENCS
  - **Password**: your ENCS password
- Click **Connect**.
- Once connected, the share will open in the file manager.
- Navigate to your personal folder inside `speed_scratch`. If it does not exist, create it.