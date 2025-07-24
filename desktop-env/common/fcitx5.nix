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
      kdePackages.fcitx5-qt # alternatively, kdePackages.fcitx5-qt
      fcitx5-chinese-addons # table input method support
      fcitx5-nord # a color theme
    ];
  };
}
