{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./env
      ./..
    ];
  
  networking.hostName = "aura-main-server";

  # nix.settings.substituters = [ "https://mirrors.ustc.edu.cn/nix-channels/store" ];
  services.pcscd.enable = true;

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
  ];

  # networking.hostName = "nixos"; # Define your hostname.

  services.openssh.enable = true;
  services.openssh.passwordAuthentication = true;
  services.openssh.permitRootLogin = "yes";
  users.users.root.initialPassword = "qwq2330319/..e";

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # 网卡名称
  networking.interfaces.eno1.ipv4.addresses = [ {
    address = "198.27.74.153";
    prefixLength = 24;  # 255.255.255.0
  } ];

  networking.interfaces.eno1.ipv6.addresses = [ {
    address = "2607:5300:60:2599::1";
    prefixLength = 64;
  } ];

  # 默认网关
  networking.defaultGateway = "198.27.74.254";
  networking.defaultGateway6 = "2607:5300:60:25ff:ff:ff:ff:ff";

  # DNS
  networking.nameservers = [
    "8.8.8.8"
    "1.1.1.1"
    "2001:4860:4860::8888"
    "2606:4700:4700::1111"
  ];

  system.stateVersion = "26.05"; # Did you read the comment?
}

