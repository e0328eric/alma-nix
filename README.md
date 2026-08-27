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
