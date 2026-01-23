{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        fcitx5-rime
        fcitx5-gtk
        fcitx5-nord
        dbus
        qt6Packages.fcitx5-chinese-addons
        kdePackages.fcitx5-qt
        qt6Packages.fcitx5-configtool
        rime-data
        librime
      ];
    };
  };

  # GNOME Shell extension for Fcitx5 input method panel
  environment.systemPackages = with pkgs; [
    gnomeExtensions.kimpanel
  ];

  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx5";
    QT_IM_MODULE = "fcitx5";
    XMODIFIERS = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
    GLFW_IM_MODULE = "ibus";
  };
}
