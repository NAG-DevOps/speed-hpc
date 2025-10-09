@echo off
:: Concordia University
:: Faculty of Engineering and Computer Science
:: SPEED Cluster Mapping Utility
:: ============================================
:: Updated: October 2025
:: Author: F. Salhany (based on S. Belanger original)
:: --------------------------------------------
:: This batch file launches the PowerShell script
:: to map \\filer-speed.encs.concordia.ca\speed_scratch
:: to the configured drive letter (default: Y:)

"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" ^
  -NoLogo -NoProfile -Sta -ExecutionPolicy Bypass ^
  -File "%~d0%~p0Speed_Scratch_Windows_Map.ps1"

pause