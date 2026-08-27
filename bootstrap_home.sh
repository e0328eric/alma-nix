#!/usr/bin/env bash

set -xe

mv ~/.nixos/hardware-configuration.nix ~/.nixos/hardware-configuration.nix.old
cp /etc/nixos/hardware-configuration.nix ~/.nixos/hardware-configuration.nix
sudo nixos-rebuild switch --flake ~/.nixos#almanixos
reboot
