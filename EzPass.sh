#!/usr/bin/env bash
set -euo pipefail

DB=""          # KeePass Database
KEYFILE=""     # KeePass Key File
ENTRY=""       # Name of KeePass Entry
TARGET_USER="" # User
TAG=""         # DataBase Name

LIB="/usr/local/lib/ezpass/lib.sh"
if [[ ! -f "$LIB" ]]; then
  echo "Missing $LIB - see README for install steps" >&2
  exit 1
fi
# shellcheck source=lib.sh
source "$LIB"

apply_password
