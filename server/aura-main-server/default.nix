{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./env
    ./..
  ];

  networking.hostName = "aura-main-server";

  # 公网服务器：使用 LTS 内核（6.12 是当前 LTS）
  boot.kernelPackages = pkgs.linuxPackages_6_12;

  services.pcscd.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── SSH ───────────────────────────────────────────────────────────
  # 公网机器：禁用密码登录，仅允许 SSH key
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password"; # 允许 root 用 key，禁止密码
    };
  };

  # TODO: 填入你的 SSH 公钥后再 rebuild，否则登录会被锁
  users.users.root.openssh.authorizedKeys.keys = [
    # "ssh-ed25519 AAAA... your-key-comment"
  ];

  # TODO: 用 `mkpasswd -m sha-512` 生成 hash 后填入，删掉旧的明文密码
  # users.users.root.hashedPassword = "$6$...";

  # ── Network ───────────────────────────────────────────────────────
  networking.networkmanager.enable = true;

  networking.interfaces.eno1.ipv4.addresses = [
    {
      address = "198.27.74.153";
      prefixLength = 24;
    }
  ];

  networking.interfaces.eno1.ipv6.addresses = [
    {
      address = "2607:5300:60:2599::1";
      prefixLength = 64;
    }
  ];

  networking.defaultGateway = "198.27.74.254";
  networking.defaultGateway6 = "2607:5300:60:25ff:ff:ff:ff:ff";

  networking.nameservers = [
    "8.8.8.8"
    "1.1.1.1"
    "2001:4860:4860::8888"
    "2606:4700:4700::1111"
  ];

  # ── Firewall ──────────────────────────────────────────────────────
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22 # ssh
    ];
    allowedUDPPorts = [ ];
  };

  system.stateVersion = "26.05";
}
