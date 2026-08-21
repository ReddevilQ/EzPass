# EzPass

A simple way to use 2 passwords at the same time: one long password for
first login (set automatically at boot), and one hard password that the
account reverts to before shutdown/reboot. Both passwords live in a
KeePassXC database.

## Requirements
- `keepassxc-cli`
- `chpasswd`

Have a KeePassXC database protected by a key file only (no password), with
two entries: one for the easy/first-login password and one for the hard
password.

## How it works
- `EzPass.service` runs `EzPass.sh` as root at boot, setting the account
  password to the **easy** entry (`EZKEE`) so first login is quick.
- `hardpass.shutdown` is a systemd shutdown hook that runs `HardPass.sh` as
  root on **every** reboot/poweroff/halt/kexec — regardless of how it was
  triggered (GUI power menu, `reboot`, `systemctl poweroff`, etc.) — setting
  the account password back to the **hard** entry (`HARDKEE`). This replaces
  the old approach of aliasing `shutdown` in `.zshrc`, which silently skipped
  the password reset on any other shutdown path.

Because both `EzPass.sh` and `HardPass.sh` run as root in these two paths,
neither needs `sudo` to call `chpasswd`.

## Install
1. Edit the variables (`DB`, `KEYFILE`, `TARGET_USER`) at the top of
   `EzPass.sh` and `HardPass.sh` to match your KeePassXC database and target
   user.
2. Install the shared library and scripts:
   ```sh
   sudo mkdir -p /usr/local/lib/ezpass
   sudo cp lib.sh /usr/local/lib/ezpass/lib.sh
   sudo cp EzPass.sh HardPass.sh /usr/local/bin/
   sudo chmod 755 /usr/local/lib/ezpass/lib.sh /usr/local/bin/EzPass.sh /usr/local/bin/HardPass.sh
   ```
3. Install the boot service:
   ```sh
   sudo cp EzPass.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable EzPass.service
   ```
4. Install the shutdown hook:
   ```sh
   sudo cp hardpass.shutdown /usr/lib/systemd/system-shutdown/
   sudo chmod 755 /usr/lib/systemd/system-shutdown/hardpass.shutdown
   ```

## Manual testing (optional)
Running either script by hand from an interactive shell (rather than via the
service/hook) executes as your normal user, so `chpasswd` needs `sudo` and
will prompt for a password. If you want passwordless manual testing, add a
sudoers rule scoped to exactly this command, e.g. via `sudo visudo -f
/etc/sudoers.d/ezpass`:
```
nick ALL=(root) NOPASSWD: /usr/sbin/chpasswd
```
This is optional — it is **not** required for the automated boot/shutdown
flow, only for running the scripts yourself from a terminal.

## Logs
Both scripts log to syslog under their own tag:
```sh
journalctl -t EzPass
journalctl -t HardPass
```
