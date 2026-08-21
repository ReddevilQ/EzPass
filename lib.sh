#!/usr/bin/env bash
# Shared helpers for EzPass.sh / HardPass.sh. Not meant to be run directly.
# Expects DB, KEYFILE, ENTRY, TARGET_USER, TAG to be set by the caller.

need() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "Missing dependency: $1" | logger -t "$TAG"
    exit 1
  }
}

apply_password() {
  need keepassxc-cli
  need chpasswd
  need id

  id -u "$TARGET_USER" >/dev/null 2>&1 || {
    echo "No such user: $TARGET_USER" | logger -t "$TAG"
    exit 1
  }

  local password
  password="$(
    keepassxc-cli show \
      --quiet \
      --no-password \
      --key-file "$KEYFILE" \
      --attributes Password \
      "$DB" "$ENTRY" |
      head -n1
  )"

  if [[ -z "$password" ]]; then
    echo "Failed to read password from KeePass entry: $ENTRY" | logger -t "$TAG"
    exit 1
  fi

  if [[ "$(id -u)" -eq 0 ]]; then
    printf '%s:%s\n' "$TARGET_USER" "$password" | chpasswd
  else
    need sudo
    printf '%s:%s\n' "$TARGET_USER" "$password" | sudo chpasswd
  fi

  unset password
  echo "Password updated for user: $TARGET_USER" | logger -t "$TAG"
}
