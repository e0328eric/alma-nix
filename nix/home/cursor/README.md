LilpaTheme is the original animated XCursor theme. `hyprcursor.nix` converts it
with `hyprcursor-util` during the Nix build and Home Manager installs the result
as `LilpaTheme-Hyprcursor` alongside it. Hyprland uses the Hyprcursor version;
`XCURSOR_THEME` still selects the original for applications that need XCursor.
The Hyprcursor build includes Adwaita's other shapes to preserve the original
theme's `Inherits=Adwaita` behavior, including resize cursors.

The conversion preserves the 32×32 animation frames, frame delays, and hotspots.
Nearest-neighbor scaling keeps the pixel art crisp at larger cursor sizes; it
does not turn the images into vector artwork.

After changing the source cursors, rebuild from the repository root:

```sh
sudo nixos-rebuild switch --flake "path:$PWD#almanixos"
```

The `path:` form also includes the new Nix file before it is tracked by Git.
Log out and back into Hyprland to apply the cursor environment variables.

Conversion documentation:
[hyprcursor theme creation](https://github.com/hyprwm/hyprcursor/blob/main/docs/MAKING_THEMES.md).
