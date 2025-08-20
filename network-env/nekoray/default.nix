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
  programs = {
    nekoray = {
      enable = true;
      tunMode.enable = true;
    };
  };
}