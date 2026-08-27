#!/usr/bin/env bash

set -xe

REQUIRED_PARENT="/mnt/etc/nixos"
CURRENT_PARENT=$(realpath ..)

if [[ "$CURRENT_PARENT" != "$REQUIRED_PARENT" ]]; then
    echo "Error: Parent directory is not '$REQUIRED_PARENT'."
    echo "Current parent resolves to: $CURRENT_PARENT"
    exit 1
fi

echo "✔ Parent directory check passed."

DEFAULT_NIXOS_HARDWARE_MODULE=$(
    sed -n -E '
        s/^[[:space:]]*nixosHardwareModule[[:space:]]*=[[:space:]]*"([^"]*)";.*/\1/p
        s/^[[:space:]]*nixosHardwareModule[[:space:]]*=[[:space:]]*null;.*/none/p
    ' variables.nix | head -n1
)
DEFAULT_NIXOS_HARDWARE_MODULE=${DEFAULT_NIXOS_HARDWARE_MODULE:-lenovo-legion-16irx9h}

echo "Enter the nixos-hardware module attribute for this laptop."
echo "Examples: lenovo-legion-16irx9h, lenovo-thinkpad-x1-9th-gen"
read -r -p "nixos-hardware module [$DEFAULT_NIXOS_HARDWARE_MODULE] (or 'none'): " NIXOS_HARDWARE_MODULE
NIXOS_HARDWARE_MODULE=${NIXOS_HARDWARE_MODULE:-$DEFAULT_NIXOS_HARDWARE_MODULE}

if [[ "$NIXOS_HARDWARE_MODULE" == "none" ]]; then
    NIXOS_HARDWARE_VALUE="null"
elif [[ "$NIXOS_HARDWARE_MODULE" =~ ^[A-Za-z0-9._+-]+$ ]]; then
    NIXOS_HARDWARE_VALUE="\"$NIXOS_HARDWARE_MODULE\""
else
    echo "Error: nixos-hardware module must contain only letters, numbers, '.', '_', '+', or '-'."
    exit 1
fi

if grep -qE '^[[:space:]]*nixosHardwareModule[[:space:]]*=' variables.nix; then
    sed -i -E "s|^([[:space:]]*nixosHardwareModule[[:space:]]*=).*;|\\1 $NIXOS_HARDWARE_VALUE;|" variables.nix
else
    sed -i -E "/^[[:space:]]*username[[:space:]]*=/a\\  nixosHardwareModule = $NIXOS_HARDWARE_VALUE;" variables.nix
fi

echo "Configured nixos-hardware module: $NIXOS_HARDWARE_MODULE"

if [[ -f "../hardware-configuration.nix" ]]; then
    cp -f ../hardware-configuration.nix .
    echo "✔ Copied hardware-configuration.nix to current directory."
else
    echo "Error: ../hardware-configuration.nix does not exist."
    exit 1
fi

# 3. diff -s ../hardware-configuration.nix and ./hardware-configuration.nix
# This will report if files are identical (due to the -s flag)
echo "--------------- Running Diff ---------------"
diff -s ../hardware-configuration.nix ./hardware-configuration.nix
echo "--------------------------------------------"

# 4. Copy all contents in . into ..
# Note: We use -r (recursive) and -v (verbose) so you can see what is being copied.
# We use ./* to copy the contents, not the directory itself.
echo "Copying all contents from current directory to parent ($REQUIRED_PARENT)..."

shopt -s extglob dotglob
cp -rv !(.git) ..

echo "Installing NixOS"

ALMA_INSTALL=1 nixos-install --impure --flake /mnt/etc/nixos#almanixos
nixos-enter --root /mnt -c 'passwd almagest'
reboot
