{ pkgs, ... }:
{
  # Arc B580 (Battlemage / Xe2) uses the xe kernel driver, not i915
  # modesetting is the correct Xorg/Wayland driver for Arc discrete GPUs
  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver    # VAAPI via iHD (Arc requires iHD, not i965)
      vpl-gpu-rt            # Intel VPL media runtime
      intel-compute-runtime # OpenCL + Level Zero (also enables Vulkan compute)
      libvdpau-va-gl        # VDPAU → VAAPI bridge for apps that only speak VDPAU
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      intel-media-driver
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    # Tell apps that speak VDPAU to go through VA-API
    VDPAU_DRIVER = "va_gl";
  };

  environment.systemPackages = with pkgs; [
    libva-utils
    intel-gpu-tools
    clinfo
    nvtopPackages.intel
  ];
}
