{ pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nouveau" ];

  # GSP firmware for Pascal (GP107) is in linux-firmware / redistributable firmware
  hardware.enableRedistributableFirmware = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  environment.sessionVariables = {
    # Electron/Chromium apps use native Wayland backend — fixes cursor/canvas flicker
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    libva-utils
  ];
}
