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
  services.mihomo = {
    enable = true;
    tunMode = true;
    webui = pkgs.metacubexd;
    # configFile = "";
  };
}
