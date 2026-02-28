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
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Enable fcitx5 autostart for GNOME
  services.desktopManager.gnome.sessionPath = [ config.i18n.inputMethod.package ];

  # Install GNOME extensions for system tray support
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.tray-icons-reloaded
  ];

  # Fix window buttons layout to include minimize and maximize buttons
  programs.dconf.profiles.user.databases = [{
    settings = {
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };
    };
  }];
}
