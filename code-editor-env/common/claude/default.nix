{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
  ];
  environment.systemPackages = with pkgs; [ 
    claude-code
    termius
  ];
}
