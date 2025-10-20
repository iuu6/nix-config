{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ./code-editor-env.nix
    ./desktop-env.nix
    ./compiler-env.nix
    ./network-env.nix
  ];
}
