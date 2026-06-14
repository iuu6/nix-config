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

  # cherry-studio 依赖 electron-38.8.4，bitwarden-desktop 依赖 electron-39.8.10，
  # 两者在 nixpkgs 中均已被标记为 insecure，需要显式放行。
  nixpkgs.config.permittedInsecurePackages = [
    "electron-38.8.4"
    "electron-39.8.10"
  ];

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
    rustdesk
    wireguard-tools
    mqttx
    gns3-gui
    minicom
  ];

  services.openwebrx.enable = true;
  hardware.rtl-sdr.enable = true;

  system.stateVersion = "25.11";
}
