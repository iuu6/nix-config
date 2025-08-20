{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./env
      ./..
    ];
  
  networking.hostName = "aura-latitude-5420";

  # nix.settings.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];

  users.users.aura = {
    isNormalUser = true;
    description = "aura";
    extraGroups = ["wheel"];
    initialPassword = "pass";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    telegram-desktop
    snipaste
    spotify
    _64gram
    _1password-gui
    typora
    kdePackages.kleopatra
    syncthing
    tsukimi
    onlyoffice-desktopeditors
    cherry-studio
    praat
    nixos-anywhere
    geogebra
    remmina
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

}

