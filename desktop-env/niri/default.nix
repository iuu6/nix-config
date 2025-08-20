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
  programs.niri = {
    # Install the packages from nixpkgs
    enable = true;
  };
}
