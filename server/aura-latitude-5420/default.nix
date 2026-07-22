{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./env
    ./..
    ./../../hardware-env/removable/proxmark3
    ./../../hardware-env/graphics/intel
  ];

  networking.hostName = "aura-latitude-5420";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  services.pcscd.enable = true;

  users.users.aura = {
    isNormalUser = true;
    description = "aura";
    extraGroups = [ "wheel" ];
    initialPassword = "pass";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    telegram-desktop
    spotify
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
    wine
    protontricks
    protonplus
    lumafly
    minio-client
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
