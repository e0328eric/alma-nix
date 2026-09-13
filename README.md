## First Installation
use the command when installing
```
nixos-install --flake /mnt/etc/nixos#almanixos
nixos-enter --root /mnt -c 'passwd almagest'
reboot
```

## Update NixOS
```
sudo nixos-rebuild switch --flake ~/.nixos#almanixos
```

## Garbage Collecting
```
nix-collect-garbage
```

after entering user, place this folder with the name `~/.nixos`

## Gaming
### Steam
```console
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only VKD3D_CONFIG=dxr11,dxr PROTON_ENABLE_NVAPI=1 %command%
```

If steam is not working through vicinae or noctalia, run the following commands
```console
mkdir -p ~/.local/share/applications
cp /run/current-system/sw/share/applications/steam.desktop ~/.local/share/applications/
sed -i 's/^Exec=steam/Exec=\/run\/current-system\/sw\/bin\/steam/g' ~/.local/share/applications/steam.desktop
```

One can debug desktop files using vicinae. Kill the server of vicinae, and run
```console
vicinae server &
```
and see the log of the vicinae

### Flatpak for Game
Notice that I personally save all contents on `/game` directory.
```console
flatpak remote-add flathub https://flathub.org/repo/flathub.flatpakrepo
flatpak install flathub <program package>
```
and one can run the program with
```console
flatpak run <program package>
```

However, in general, the ownership will be root. So first of all, run
```console
sudo chown -R almagest:users /game/flatpak
```

#### Twintail Launcher Setting
Run the following commands
```console
sudo mount --bind <the-directory> ~/.var/app/app.twintaillauncher.ttl
```
where `<the-directory>` is the one where games are actually located.
Then add the following into the `hardware-configuration.nix`
```nix
fileSystems."/home/<username>/.var/app/app.twintaillauncher.ttl" = {
  device = "<the-directory>";
  fsType = "none";
  options = [ "bind" ];
};
```

## Troubleshooting
### Save git passwords
```console
git config --global credential.helper store
```

### Bluetooth is not working
Open your terminal (ghostty or kitty).

Run the Bluetooth control tool:

```console
bluetoothctl
```
Inside the [bluetooth]# prompt, run these commands in order:

```console
power on
agent on
default-agent
```

Then connect devices by the following order
```console
remove <device_id>   <-- For the first time, one may skip this
pair <device_id>
trust <device_id>    <-- Do not skip this step!
connect <device_id>
```

## headset connection works, but sound glitches all the time
Run
```console
pactl set-port-latency-offset <bluez_card> headset-output 125000
```
where `<bluez_card>` is
`pactl list cards short | grep bluez`

### Thunderbird cannot save password
The Fix: Delete pkcs11.txt
This file manages security modules. If it is broken, Thunderbird cannot save
passwords to its database. Deleting it forces Thunderbird to generate a fresh,
working one.

1. Close Thunderbird completely.
2. Open your terminal.
3. Navigate to your Thunderbird profile directory. It is usually inside `~/.thunderbird/`.
```console
cd ~/.thunderbird
ls
```
4. You will see a folder with a random name ending in `.default` or `.default-release`
(e.g., `a1b2c3d4.default`).
5. Enter that folder:
```console
cd *.default*
```
6. Delete the `pkcs11.txt` file:
```console
rm pkcs11.txt
```
7. Restart Thunderbird.
8. Enter your password one last time and check "Use Password Manager...". It should now stick.

### installing MATLAB
First of all, download MATLAB zip file. Then run the following script.
```console
mkdir <matlab-installation-dir>
mv <matlab-zip> <matlab-installation-dir>
cd <matlab-installation-dir>
unzip <matlab-zip>
matlab-fhs
QT_QPA_PLATFORM=xcb QT_QPA_PLATFORMTHEME="" QT_STYLE_OVERRIDE="" ./install
```
Then make a desktop file `~/.local/share/applications/matlab-fhs.desktop` with
```console
[Desktop Entry]
Name=MATLAB (FHS)
Comment=MATLAB R2025b via FHS environment
Type=Application
Terminal=false
Exec=matlab-fhs -c "QT_SCALE_FACTOR=1.6 QT_QPA_PLATFORM=xcb QT_QPA_PLATFORMTHEME= QT_STYLE_OVERRIDE= matlab"
Icon=/home/almagest/.local/MATLAB/R2025b/bin/glnxa64/matlab.png
Categories=Development;Science;
StartupNotify=true
```

### QEMU / KVM not connected
First run the following commands
```console
systemctl status virtqemud.service virtqemud.socket libvirtd.service libvirtd.socket
ls -l /run/libvirt
```
If libvirtd.socket failes, then run these commands
```console
sudo systemctl stop libvirtd.socket libvirtd.service
sudo systemctl reset-failed libvirtd.socket libvirtd.service
```

### VM network `default` failed
```console
sudo virsh net-list --all
sudo virsh net-start default
sudo virsh net-autostart default
```

### Fingerprint
SDDM (through the `login` PAM service) and `sudo` try fingerprint authentication
first. Three failed scans or a 10-second timeout falls back to password authentication.
These settings also apply to TTY login, which uses the same `login` PAM service.

For `sudo`, the password prompt appears after fingerprint authentication fails or
times out. Use `sudo -k true` to test without a cached sudo authentication.

In SDDM, select your user and press Enter with the password field empty to start
the fingerprint scan. If it fails or times out, enter your password and submit
again. SDDM starts a new authentication attempt, so let its fingerprint stage fail
or time out before the submitted password is checked. SDDM does not display a new
interactive password prompt during an ongoing authentication attempt.

run `sudo fprintd-enroll -f right-index-finger "$USER"`.
Here, the followings are available finger names

- left-thumb
- left-index-finger
- left-middle-finger
- left-ring-finger
- left-little-finger
- right-thumb
- right-index-finger
- right-middle-finger
- right-ring-finger
- right-little-finger

### Passkeys on this laptop

`nix/root/passkeys.nix` runs [linux-id](https://github.com/matejsmycka/linux-id)
as a user service. It exposes a virtual FIDO2 security key to browsers, using the
laptop's TPM 2.0 for private keys and fprintd for fingerprint verification. GNOME
Keyring continues to store browser secrets; it is separate from this authenticator.
The Hyprland startup configuration also starts the service explicitly because this
session does not activate `graphical-session.target`.

Apply the configuration and reboot once so the `uhid` module, device permissions,
and user service are active:

```console
sudo nixos-rebuild switch --flake ~/.nixos#almanixos
reboot
```

Check that the service is running:

```console
systemctl --user status linux-id
fido2-token -L
```

In Brave, open [the Yubico WebAuthn demo](https://demo.yubico.com/webauthn-technical/registration)
and register a test passkey. Choose **Security key** when asked where to save it,
then touch the laptop's fingerprint reader when the browser asks you to touch the
key. Test authentication with the same passkey before adding one to a real account.
No browser extension is needed. Fingerprint failure rejects the passkey attempt;
use the website's other sign-in methods if necessary.

This is a community authenticator, not a built-in Brave or GNOME platform
authenticator. Sites that require a platform authenticator, security-key PIN, or
unsupported CTAP extensions may not work. Fingerprint verification is enforced by
the daemon, not by a hardware-isolated biometric system. The daemon briefly caches
successful fingerprint verification for browser retries (five seconds).

Resident credentials are stored in `~/.config/linux-id/creds.json`; back up this
directory. The credentials can only be used with the original TPM, so clearing the
TPM or replacing the motherboard can make them unusable even with a file backup.
Keep an additional passkey or recovery method on important accounts.

For troubleshooting or to temporarily remove the virtual key:

```console
journalctl --user -u linux-id -b
systemctl --user stop linux-id
systemctl --user start linux-id
```
