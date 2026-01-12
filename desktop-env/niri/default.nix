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
  programs.niri.enable = true;
  
  environment.etc."xdg/niri/config.kdl".source = ./config.kdl;
}
