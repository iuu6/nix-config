{ pkgs, ... }:
let
  appDir = "/home/fdu-alumni/Server/alumni-server";
  appUser = "fdu-alumni";
in
{
  systemd.services.alumni-server = {
    description = "Fudan alumni server (alumni-server)";
    wantedBy = [ "multi-user.target" ];
    wants = [
      "network-online.target"
      "mongodb.service"
    ];
    after = [
      "network-online.target"
      "mongodb.service"
    ];

    serviceConfig = {
      Type = "simple";
      User = appUser;
      Group = "users";
      WorkingDirectory = appDir;
      ExecStart = "${pkgs.bun}/bin/bun ${appDir}/out/main.js";

      Restart = "on-failure";
      RestartSec = 5;
      TimeoutStopSec = 20;
      KillSignal = "SIGTERM";

      Environment = [
        "HOME=/home/fdu-alumni"
        "PATH=${pkgs.bun}/bin:/run/current-system/sw/bin"
      ];

      StandardOutput = "journal";
      StandardError = "journal";
    };
  };
}
