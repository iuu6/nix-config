{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ./common/font.nix
    ./common/fcitx5.nix
    ./common/useful.nix
  ];
  programs.ssh.enableAskPassword = false;
}
