{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./env
    ./docker.nix
    ./sync.nix
    ./..
  ];

  networking.hostName = "aura-main-data";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 数据盘挂载。必须按 UUID：/dev/mdN 的编号在重启后会变
  # （实测中我们的阵列曾从 md125 变成 md127）。
  # nofail + 30s 超时：这是远端机器，阵列未组装时若卡住启动将无法 SSH 进去。
  fileSystems."/mnt/core-data" = {
    device = "/dev/disk/by-uuid/9578a63e-240d-4e20-b306-69b589ab547f";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.device-timeout=30s" ];
  };

  fileSystems."/mnt/main-data" = {
    device = "/dev/disk/by-uuid/3dfaf2c8-022f-4a93-a808-1dc1011f733b";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.device-timeout=30s" ];
  };

  fileSystems."/mnt/temp-data" = {
    device = "/dev/disk/by-uuid/ea1ab7f5-64b2-4a25-b301-c1be16b15d54";
    fsType = "ext4";
    options = [ "defaults" "nofail" "x-systemd.device-timeout=30s" ];
  };

  # Software RAID (mdadm)
  boot.swraid.enable = true;
  boot.swraid.mdadmConf = ''
    MAILADDR root
    ARRAY /dev/md/important UUID=e62fab20:b995de1c:fef3b61c:8df98bea
    ARRAY /dev/md/main UUID=44748fe0:e9a6db51:437bc9cd:44fb1607
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

  # syncthing 数据目录在 /mnt/main-data 上，必须等挂载完成再启动，
  # 否则它会看到根分区上的空挂载点并因权限不足而失败（实测已发生）。
  systemd.services.syncthing.unitConfig.RequiresMountsFor = "/mnt/main-data/syncthing";

  services.syncthing = {
    enable = true;
    user = "aura";
    dataDir = "/mnt/main-data/syncthing";
  };

  # services.filebrowser = {
  #   enable = true;
  #   port = 8080;
  # };

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
