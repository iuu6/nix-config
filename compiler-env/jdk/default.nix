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
    jdk23
  ];
}
