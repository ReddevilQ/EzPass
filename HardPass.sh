#!/usr/bin/env bash
set -euo pipefail

DB="${HOME}/Documents/Passwords.kdbx"
KEYFILE="${HOME}/Documents/KeeKee"
ENTRY="HARDKEE"
TARGET_USER="${USER}"

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing dependency: $1" >&2
    exit 1
  }
}

need keepassxc-cli
need sudo
need chpasswd

password="$(
  keepassxc-cli show \
    --quiet \
    --no-password \
    --key-file "$KEYFILE" \
    --attributes Password \
    "$DB" "$ENTRY" |
    head -n1
)"

if [[ -z "${password}" ]]; then
  exit 1
fi

printf '%s:%s\n' "$TARGET_USER" "$password" | sudo chpasswd

unset password
