{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    # ./../../../network-env/mihomo
    ./../../../network-env/clash-verge
  ];
}
