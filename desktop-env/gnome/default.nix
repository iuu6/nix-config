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
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
  };
}
