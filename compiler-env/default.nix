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
    just
    direnv
    devenv
    docker
  ];
}