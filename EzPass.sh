#!/usr/bin/env bash
set -euo pipefail

DB="/home/nick/Documents/Passwords.kdbx"
KEYFILE="/home/nick/Documents/KeeKee"
ENTRY="EZKEE"
TARGET_USER="nick"
TAG="EzPass"

LIB="/usr/local/lib/ezpass/lib.sh"
if [[ ! -f "$LIB" ]]; then
  echo "Missing $LIB - see README for install steps" >&2
  exit 1
fi
# shellcheck source=lib.sh
source "$LIB"

apply_password
