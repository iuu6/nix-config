{ config, pkgs, ... }:
{
  services.xserver.videoDrivers = [ "nvidia" ];

  # GDM must use X11 backend — running GDM in Wayland while the GNOME session
  # uses X11 causes hard GPU hangs under heavy load (gaming) with NVIDIA
  services.displayManager.gdm.wayland = false;

  # PAT gives the driver a faster, stable memory path; without it Quadro P600
  # (2 GB VRAM) can hard-crash the X session when VRAM is saturated by a game
  boot.extraModprobeConfig = ''
    options nvidia NVreg_UsePageAttributeTable=1
  '';

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
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
    extraPackages32 = with pkgs.pkgsi686Linux; [
      nvidia-vaapi-driver
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
    # Force NVIDIA GLX vendor to avoid Wayland/XWayland lookup failures
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  environment.systemPackages = with pkgs; [
    libva-utils
    nvtopPackages.nvidia
  ];
}
