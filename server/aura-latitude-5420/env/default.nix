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
  ]
}
