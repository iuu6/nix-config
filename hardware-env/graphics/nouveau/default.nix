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
    nvtopPackages.full
  ];

  # Set nouveau GPU to max performance pstate at boot
  systemd.services.nouveau-pstate = {
    description = "Set Nouveau GPU pstate to maximum performance";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udev-settle.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo 0f > /sys/class/drm/card0/device/pstate'";
    };
  };
}
