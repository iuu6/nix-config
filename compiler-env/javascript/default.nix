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
  environment.systemPackages = with pkgs; [
    bun
    nodejs_24
  ];
}
