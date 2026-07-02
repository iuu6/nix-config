{ pkgs, ... }:
{
  imports = [
    ./../hardware-env/wireless/bluetooth
  ];

  nix.settings = {
    substituters = [
      # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      # "https://mirrors.ustc.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];
    trusted-users = [
      "root"
      "@wheel"
    ];
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    warn-dirty = false;
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  boot.supportedFilesystems = [ "ntfs" ];

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    # base system
    git
    nano
    wget
    sudo
    vim
    gnutar
    openssl
    gnupg
    ffmpeg

    pciutils # lspci
    usbutils # lsusb
    smartmontools # smartctl
    tree
    inetutils # telnet
    traceroute

    nmap
    bind
    qemu_full

    htop
    btop
    lm_sensors
    ethtool
    hyfetch
    fastfetch

    nil
    nixfmt
    nix-output-monitor
  ];

  i18n.supportedLocales = [
    "en_US.UTF-8/UTF-8"
    "zh_CN.UTF-8/UTF-8"
    "C.UTF-8/UTF-8"
  ];
  i18n.defaultLocale = "en_US.UTF-8";

  boot.tmp.cleanOnBoot = true;

  time.timeZone = "Asia/Shanghai";

  services.timesyncd.enable = true;
  services.timesyncd.servers = [
    "ntp.tencent.com"
    "ntp1.aliyun.com"
    "ntp.ntsc.ac.cn"
    "cn.ntp.org.cn"
  ];
}
