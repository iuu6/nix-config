{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ./..
  ];
  systemd.services.clash-verge = {
    enable = true;
    description = "Clash Verge Service Mode";
    serviceConfig = {
      ExecStart = "${config.programs.clash-verge.package}/bin/clash-verge-service";
      Restart = "on-failure";
    };
    wantedBy = ["multi-user.target"];
  };
}
