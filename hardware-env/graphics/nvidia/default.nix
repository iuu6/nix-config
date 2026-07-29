{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    # Quadro P600 is Pascal (GP107GL), does not support open kernel module
    open = false;
    nvidiaSettings = true;
    # Quadro P600 (Pascal) is dropped from stable 590+, requires legacy 580.xx
    package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };

  environment.systemPackages = with pkgs; [
    libva-utils
    nvtopPackages.nvidia
  ];
}
