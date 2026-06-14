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

  # Install GNOME extensions for system tray support and tiling window management
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.paperwm
    gnomeExtensions.system-monitor-next
  ];

  # Fix window buttons layout to include minimize and maximize buttons
  # and enable AppIndicator/KStatusNotifierItem support extension
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
        };
        "org/gnome/shell" = {
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "trayIconsReloaded@selfmade.pl"
            "paperwm@paperwm.github.com"
            "system-monitor-next@paradoxxx.zero.gmail.com"
          ];
        };
        # Free up keybindings that conflict with PaperWM
        "org/gnome/desktop/wm/keybindings" = {
          move-to-monitor-left = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          move-to-monitor-right = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          move-to-monitor-up = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          move-to-monitor-down = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          maximize = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          unmaximize = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
        };
        "org/gnome/mutter/keybindings" = {
          toggle-tiled-left = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          toggle-tiled-right = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
        };
      };
    }
  ];
}
