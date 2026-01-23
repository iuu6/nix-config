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
  services.xserver.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable fcitx5 autostart for GNOME
  services.desktopManager.gnome.sessionPath = [ config.i18n.inputMethod.package ];
}
