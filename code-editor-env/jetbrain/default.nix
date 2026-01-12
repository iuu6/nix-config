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
  environment.systemPackages = with pkgs; [ jetbrains.idea ];
}
