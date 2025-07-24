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

  programs.clash-verge = {
    enable = true;
    package = pkgs.clash-verge-rev;
    autoStart = false;
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.services.clash-verge = {
    enable = true;
    description = "Clash Verge Service Mode";
    serviceConfig = {
      ExecStart = "${config.programs.clash-verge.package}/bin/clash-verge-service";
      Restart = "on-failure";
    };
    wantedBy = ["multi-user.target"];
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    xournalpp
    telegram-desktop
    snipaste
    spotify
    _64gram
    _1password-gui
    typora
    kdePackages.kleopatra
    gnupg
    syncthing
    libsForQt5.kamoso
    tsukimi
    onlyoffice-desktopeditors
    cherry-studio
    praat
  ];

  system.stateVersion = "25.05"; # Did you read the comment?

}

