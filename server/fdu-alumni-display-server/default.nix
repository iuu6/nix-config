{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./env
    ./..
  ];

  networking.hostName = "fdu-alumni-display-server";

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 展示机大概率是核显（Intel/AMD），modesetting + 基础图形栈即可。
  # 如果确认是 NVIDIA 独显，改为 import ../../hardware-env/graphics/nvidia；
  # Intel Arc 则改为 ../../hardware-env/graphics/intel-arc。
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  users.users.aura = {
    isNormalUser = true;
    description = "aura";
    extraGroups = [ "wheel" ];
    # 仅用于本地控制台登录和 sudo；SSH 已禁用密码认证。
    # 首次装机后请立即用 passwd 修改。
    initialPassword = "pass";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBTsouUebiV44aXue/fERTiquKm1XAlbqSAHWgIZPp1V"
    ];
  };

  # 仅允许密钥登录
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # RustDesk 客户端 + 常驻服务，便于无人值守远程接入图形会话
  environment.systemPackages = with pkgs; [
    rustdesk
  ];

  systemd.services.rustdesk = {
    description = "RustDesk remote desktop service";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.rustdesk}/bin/rustdesk --service";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # 如果这台机器还要充当 RustDesk 中继（hbbs/hbbr），取消下面两行注释。
  # 仅作为被控端时不需要，客户端只主动向外连接。
  # services.rustdesk-server.enable = true;
  # services.rustdesk-server.openFirewall = true;

  # 展示机若需要开机直接进入 GNOME 桌面，取消下面注释。
  # services.displayManager.autoLogin = {
  #   enable = true;
  #   user = "aura";
  # };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.05";
}
