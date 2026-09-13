{ pkgs, ... }:
let
  vars = import ../../variables.nix;
  username = vars.username or "almagest";
  linuxId = pkgs.callPackage ../../pkgs/linux-id.nix { };
in
{
  security.tpm2.enable = true;
  services.fprintd.enable = true;
  boot.kernelModules = [ "uhid" ];

  # Run before systemd's seat rules so logind grants the active local user
  # access to the TPM resource manager and virtual HID device interface.
  services.udev.packages = [
    (pkgs.writeTextDir "lib/udev/rules.d/70-linux-id.rules" ''
      KERNEL=="uhid", SUBSYSTEM=="misc", TAG+="uaccess"
      KERNEL=="tpmrm0", SUBSYSTEM=="tpmrm", TAG+="uaccess"
      SUBSYSTEM=="hidraw", KERNELS=="0003:15D9:0A37.*", TAG+="uaccess"
    '')
  ];

  environment.systemPackages = [ linuxId ];

  systemd.user.services.linux-id = {
    description = "TPM-backed passkeys with fingerprint verification";
    documentation = [ "https://github.com/matejsmycka/linux-id" ];
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session-pre.target" ];
    partOf = [ "graphical-session.target" ];
    unitConfig.ConditionUser = username;
    environment.PINENTRY_PATH = "${pkgs.pinentry-qt}/bin/pinentry-qt";
    serviceConfig = {
      ExecStart = "${linuxId}/bin/linux-id --backend tpm --device /dev/tpmrm0 --auth fprintd";
      Restart = "on-failure";
      RestartSec = 3;
      UMask = "0077";
      NoNewPrivileges = true;
      PrivateTmp = true;
      ProtectSystem = "strict";
      ReadWritePaths = [ "%h/.config" ];
      ProtectKernelTunables = true;
      ProtectKernelModules = true;
      ProtectControlGroups = true;
      RestrictAddressFamilies = [ "AF_UNIX" ];
      RestrictSUIDSGID = true;
      LockPersonality = true;
    };
  };
}
