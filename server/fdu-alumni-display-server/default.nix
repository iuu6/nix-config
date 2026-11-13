{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./env
    ./backup.nix
    ./alumni-server.nix
    ./..
    # UGREEN AIC8800 USB 无线网卡（a69c:8d80）的树外驱动。
    ./../../hardware-env/wireless/aic8800
  ];

  networking.hostName = "fdu-alumni-display-server";

  environment.systemPackages = with pkgs; [
    onlyoffice-desktopeditors
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # 展示机大概率是核显（Intel/AMD），modesetting + 基础图形栈即可。
  # 如果确认是 NVIDIA 独显，改为 import ../../hardware-env/graphics/nvidia；
  # Intel Arc 则改为 ../../hardware-env/graphics/intel-arc。
  services.xserver.videoDrivers = [ "modesetting" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  users.users.fdu-alumni = {
    isNormalUser = true;
    description = "fdu-alumni";
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

  # GNOME 原生 RDP（Wayland，Windows mstsc 可直接连接）。
  # GNOME 模块默认已启用，这里显式写出便于查找。
  #
  # 首次使用需要在已登录的 GNOME 会话里配置（二选一）：
  #   图形界面：设置 → 系统 → 远程桌面，开启并设置用户名/密码
  #   命令行：  grdctl rdp enable
  #             grdctl rdp set-credentials <用户名> <密码>
  # 无本地登录/无显示器场景可用 headless 模式：
  #             grdctl --headless rdp enable
  #             grdctl --headless rdp set-credentials <用户名> <密码>
  #
  # RDP 仍是密码认证，不支持 SSH 密钥。密钥方案是 SSH 隧道：
  #   ssh -L 3389:127.0.0.1:3389 fdu-alumni@<server>
  # 然后 RDP 客户端连 127.0.0.1:3389（3389 默认不对外开放）。
  # 若要客户端直连，再把 3389 加入 networking.firewall.allowedTCPPorts。
  services.gnome.gnome-remote-desktop.enable = true;

  # 允许局域网内 Windows mstsc 直连 GNOME RDP（3389）。
  networking.firewall.allowedTCPPorts = [
    3389 # GNOME RDP
    30001 # alumni-server HTTP
    30002 # alumni-server WebSocket
  ];

  # 如果这台机器还要充当 RustDesk 中继（hbbs/hbbr），取消下面两行注释。
  # 仅作为被控端时不需要，客户端只主动向外连接。
  # services.rustdesk-server.enable = true;
  # services.rustdesk-server.openFirewall = true;

  # 展示机若需要开机直接进入 GNOME 桌面，取消下面注释。
  # services.displayManager.autoLogin = {
  #   enable = true;
  #   user = "fdu-alumni";
  # };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "26.05";
}
