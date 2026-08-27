{ pkgs, ... }:
{
  # nbfc-linux picks its temperature sensors from the "@CPU" alias
  # (coretemp/k10temp/zenpower), so coretemp must be loaded before the service
  # starts, otherwise it dies with "No temperatures available".
  boot.kernelModules = [ "coretemp" ];

  # ensure that nbfc-linux is installed
  systemd.services.nbfc = {
    enable = true;
    description = "NoteBook FanControl Service";
    # nbfc_service shells out to `modprobe` for the EC access modules
    # (ec_sys / acpi_ec / acpi_call); without kmod it falls back to dev_port.
    path = [ pkgs.kmod ];
    after = [ "systemd-modules-load.service" ];
    serviceConfig = {
      Type = "simple";
      # We point directly to the binary in the nix store
      ExecStart = "${pkgs.nbfc-linux}/bin/nbfc_service --config-file '/etc/nbfc/nbfc.json'";
      Restart = "on-failure";
      RestartSec = 5;
    };
    wantedBy = [ "multi-user.target" ];
  };

  # Ensure the config directory exists and set the config file
  # REPLACE "Lenovo IdeaPad 330-15IKB" WITH YOUR SPECIFIC MODEL STRING
  systemd.tmpfiles.rules = [
    "d /etc/nbfc 0755 root root -"
    "f /etc/nbfc/nbfc.json 0644 root root - {\"SelectedConfigId\": \"Lenovo V330-IKB(81AX)\"}"
  ];
}
