# EzPass
A simple way to use 2 passwords at the same time one long for First Login and one for After First Login. plan is to have the passwords secure in KeePass XC

KeePassXC-CLI doesn't have native wl-copy support, but you can fake xclip by wrapping wl-copy so KeePassXC calls it instead:

bash
# Create a wrapper script (e.g., in /usr/local/bin/xclip)
cat > /usr/local/bin/xclip << 'EOF'
#!/bin/sh
wl-copy
EOF
chmod +x /usr/local/bin/xclip

Then run:

bash
keepassxc-cli clip your_database.kdbx "entry/path"

KeePassXC will call your xclip wrapper, which passes the password to wl-copy for the Wayland clipboard.
Make it permanent (optional)

Add this to your shell config (~/.bashrc or ~/.zshrc):

bash
export PATH="/usr/local/bin:$PATH"

Or create an alias:

bash
alias keepassxc-cli='PATH="/usr/local/bin:$PATH" keepassxc-cli'

This works because KeePassXC-CLI uses xclip on Unix when available, so swapping in a wrapper is the standard workaround.

Do you want this to auto-clear the clipboard after a few seconds (like wl-copy --timeout 30)?
