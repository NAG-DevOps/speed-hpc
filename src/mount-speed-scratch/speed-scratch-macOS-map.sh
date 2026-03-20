#!/bin/bash

# --- Config ---
SERVER="filer-speed.encs.concordia.ca"
SHARE="speed_scratch"
SHARE_SMB_URL="smb://${SERVER}/${SHARE}"
MOUNT_POINT="${HOME}/Speed_Scratch"

# --- Host info ---
HOSTNAME_STR="$(scutil --get ComputerName 2>/dev/null || hostname)"
echo "${HOSTNAME_STR}"

# --- Prompt for ENCS credentials ---
read -r -p "Enter your ENCS username: " USER_INPUT
# trim whitespace
USER_INPUT="${USER_INPUT#"${USER_INPUT%%[![:space:]]*}"}"
USER_INPUT="${USER_INPUT%"${USER_INPUT##*[![:space:]]}"}"

if [ -z "${USER_INPUT}" ]; then
  echo "No username entered. Exiting..."
  exit 1
fi

if [[ "${USER_INPUT}" == *\\* ]]; then
  DOMAIN="${USER_INPUT%%\\*}"
  USER_ONLY="${USER_INPUT#*\\}"
  USER_FOR_URL="${DOMAIN};${USER_ONLY}"
else
  USER_FOR_URL="${USER_INPUT}"
fi

MOUNT_URL="//${USER_FOR_URL}@${SERVER}/${SHARE}"

# --- Map logic ---
mkdir -p "${MOUNT_POINT}"

# Disconnect if already mounted (quietly)
if mount | grep -q "on ${MOUNT_POINT} "; then
  CURRENT_SRC="$(mount | awk -v mp="${MOUNT_POINT}" '$0 ~ ("on " mp " ") {print $1; exit}')"
  echo "${MOUNT_POINT} already connected! We will try to disconnect before reconnecting!"
  umount "${MOUNT_POINT}" 2>/dev/null || diskutil unmount force "${MOUNT_POINT}" >/dev/null 2>&1 || true
  sleep 0.3
  echo "${MOUNT_POINT} disconnected."
fi

# Map
echo "[+] Connecting -> ${MOUNT_URL} -> ${MOUNT_POINT}"
if ! mount_smbfs "${MOUNT_URL}" "${MOUNT_POINT}"; then
  echo "Failed to map drive."
  exit 1
fi

echo "Connected successfully."
sleep 1

# Open Finder (Explorer equivalent)
open "${MOUNT_POINT}" >/dev/null 2>&1 || true

exit 0