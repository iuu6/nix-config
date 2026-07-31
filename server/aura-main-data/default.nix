{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./env
    ./..
  ];

  networking.hostName = "aura-main-data";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Software RAID (mdadm)
  boot.swraid.enable = true;
  boot.swraid.mdadmConf = ''
    MAILADDR root
  '';

  users.users.aura = {
    isNormalUser = true;
    description = "aura";
    extraGroups = [ "wheel" ];
    initialPassword = "pass";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "aura-main-data";
        "security" = "user";
      };
    };
  };

  services.nfs.server = {
    enable = true;
    exports = ''
      # /data 192.168.1.0/24(rw,sync,no_subtree_check)
    '';
  };

  services.syncthing = {
    enable = true;
    user = "aura";
    dataDir = "/data/syncthing";
  };

  services.filebrowser = {
    enable = true;
    port = 8080;
  };

  services.qbittorrent = {
    enable = true;
    openFirewall = true;
  };

  networking.firewall.allowedTCPPorts = [
    2049  # NFS
    8384  # Syncthing webUI
    22000 # Syncthing data sync
  ];
  networking.firewall.allowedUDPPorts = [
    21027 # Syncthing discovery
  ];

  environment.systemPackages = with pkgs; [
    mergerfs
    snapraid
    mdadm
    hdparm
    smartmontools
    parted
    lsof
  ];

  system.stateVersion = "26.05";
}
