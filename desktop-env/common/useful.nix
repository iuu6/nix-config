{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    xournalpp
    cheese
    vlc
    obs-studio
    google-chrome
    # electron-chromedriver # 已移除：依赖过期的 electron-38.8.4
  ];
}
