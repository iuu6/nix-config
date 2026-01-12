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
    throne = {
      enable = true;
      tunMode.enable = true;
    };
  };
}