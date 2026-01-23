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
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      kdePackages.fcitx5-qt
      qt6Packages.fcitx5-chinese-addons
      fcitx5-nord
      fcitx5-mozc
      fcitx5-gtk
    ];
  };
}
