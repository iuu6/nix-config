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
  ];
  programs.ssh.enableAskPassword = false;
}
