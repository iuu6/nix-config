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

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    desktopManager.plasma6.enable = true;
  };

  environment.systemPackages = with pkgs; [
    orchis-theme
  ];
}
