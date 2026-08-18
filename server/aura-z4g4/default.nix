{ pkgs, ... }:
{
  nixpkgs.overlays = [
    (final: _: {
      cogfly = final.callPackage ../../packages/cogfly/package.nix { };
      soundux = final.callPackage ../../packages/soundux/package.nix { };
    })
  ];

  imports = [
    ./hardware-configuration.nix
    ./env
    ./..
    ./../../hardware-env/removable/proxmark3
    # ./../../hardware-env/graphics/nouveau
    # ./../../hardware-env/graphics/nvidia
    ./../../hardware-env/graphics/intel-arc
    ./../../hardware-env/display/ddcutil
    ./../../desktop-env/spotify
    ./../../desktop-env/steam
  ];

  networking.hostName = "aura-z4g4";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Disable HDA Intel audio power saving to prevent speaker pop/thump on idle
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0
  '';

  services.pcscd.enable = true;

  # Enable wakeup from S3 suspend for all USB controllers and hubs
  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{power/wakeup}="enabled"
  '';

  users.users.aura = {
    isNormalUser = true;
    description = "aura";
    extraGroups = [ "wheel" "video" "render" ];
    initialPassword = "pass";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  environment.systemPackages = with pkgs; [
    telegram-desktop
    _64gram
    typora
    kdePackages.kleopatra
    tsukimi
    onlyoffice-desktopeditors
    cherry-studio
    praat
    nixos-anywhere
    geogebra
    remmina
    openwebrx
    bitwarden-desktop
    adoptopenjdk-icedtea-web
    discord
    parsec-bin
    kdePackages.kolourpaint
    winbox4
    # rustdesk
    wireguard-tools
    mqttx
    gns3-gui
    minicom
    lumafly
    minio-client
    cogfly
    soundux
  ];

  services.openwebrx.enable = true;
  hardware.rtl-sdr.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "pnpm-10.29.2"
    "electron-39.8.10"
    "electron-40.10.5"
  ];

  system.stateVersion = "26.05";
}
