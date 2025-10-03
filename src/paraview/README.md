# Introduction

ParaView is an open source post-processing visualization engine.

[Paraview Website](https://www.paraview.org/)

# Paraview - Server (pvserver)

## Pre-requisites
* Install in your workstation Paraview-Desktop, recommended the same version as the Server
```bash
https://www.paraview.org/paraview-downloads/download.php?submit=Download&version=v5.13&type=binary&os=Windows&downloadFile=ParaView-5.13.2-Windows-Python3.10-msvc2017-AMD64.msi
```
## Instructions

* From the **submit** node, run the `start_paraview.sh` script each time you need to launch paraview-server

```bash
    ./start_paraview.sh
```
* Read carefully the information displayed from the script, it contains important information to create the connection between the desktop application and pvserver

# Paraview - GUI
## Instructions
* From the **submit** node, start an interactive session, with X11 activated (Important)
```bash
    salloc --x11 --mem=10Gb
```
* Run the script `paraview_GUI.sh`