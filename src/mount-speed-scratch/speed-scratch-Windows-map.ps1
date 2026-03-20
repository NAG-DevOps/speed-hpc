<#
   .SYNOPSIS
    Map Concordia ENCS High-Performance Computing (Speed) network drive
   .DESCRIPTION
    This script map speed-scratch network drive
   .NOTES
    NAME: Speed_Scratch_Windows_Map.ps1
    AUTHOR: SPEED HPC Team 
    VERSION: 1.0
    LASTEDIT: October, 2025
         V 1.0 Initial script (F. Salhany)
    KEYWORDS: Map, Network Drive
   .Link
    https://www.concordia.ca/
    https://www.concordia.ca/ginacody/aits/speed.html
#>

$ErrorActionPreference = 'Stop'
Clear-Host

# --- Config ---
$DriveLetter = 'Y:'  # <- Change this if needed
$ENCS_Path   = '\\filer-speed.encs.concordia.ca\speed_scratch'

# Host info
$Workstation = [System.Net.Dns]::GetHostEntry($env:COMPUTERNAME)
Write-Output $Workstation.HostName

# Prompt for ENCS credentials
$User = (Read-Host "Enter your ENCS username").Trim()
if (-not $User) {
   Write-Output 'No username entered. Exiting...'
   exit 1
}
$SecurePwd = Read-Host "Password" -AsSecureString
if (-not $SecurePwd) {
   Write-Output 'No password entered. Exiting...'
   exit 1
}

$Cred = New-Object System.Management.Automation.PSCredential($User, $SecurePwd)
$Pwd  = $Cred.GetNetworkCredential().Password

# --- Map logic ---
$ObjNet = New-Object -ComObject WScript.Network

# Disconnect if already mapped
try {
   $pairs = @($ObjNet.EnumNetworkDrives())
   for ($i = 0; $i -lt $pairs.Count; $i += 2) {
      if ($pairs[$i] -eq $DriveLetter) {
         Write-Output "$DriveLetter already mapped to $($pairs[$i+1]). Removing..."
         $ObjNet.RemoveNetworkDrive($DriveLetter, $true, $true)
         Start-Sleep -Milliseconds 300
         Write-Output "$DriveLetter disconnected."
         break
      }   
   }
} catch { }

# Map the drive
try {
   Write-Host "[+] Connecting $DriveLetter -> $ENCS_Path" -ForegroundColor Cyan
   $ObjNet.MapNetworkDrive($DriveLetter, $ENCS_Path, $false, $User, $Pwd)
   Write-Host "$DriveLetter connected successfully.`n" -ForegroundColor Green
} catch {
   $e = $_.Exception
   while ($e.InnerException) { $e = $e.InnerException }
   $msg = $e.Message
   Write-Host "Failed to map drive: $msg" -ForegroundColor Red
   exit 1
}

Start-Sleep -Seconds 1

# Open File Explorer to show the mapped drive
explorer.exe '/n,/e,::{20D04FE0-3AEA-1069-A2D8-08002B30309D}'

exit 0