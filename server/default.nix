{
  inputs,
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: 
{
  imports = [
    ../hardware/wireless/bluetooth
  ];
  nix.settings.substituters = [
    # "https://mirrors.ustc.edu.cn/nix-channels/store"
    # "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    "https://cache.nixos.org"
  ];
  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;

  networking.networkmanager.enable = true;
  networking.wireless.iwd.enable = true;
  networking.networkmanager.wifi.backend = "iwd";

  boot.supportedFilesystems = [
    "ntfs"
  ];

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

    pciutils # lspci
    usbutils # lsusb
    smartmontools # smartctl

    nmap
    qemu_full

    htop
    lm_sensors
    ethtool
    hyfetch
    neofetch
    fastfetch

    nil
    nixfmt-classic
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
}
