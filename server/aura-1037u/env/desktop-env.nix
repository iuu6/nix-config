{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ./../../../desktop-env/kde-plasma
    # ./../../../desktop-env/niri
  ];
}
