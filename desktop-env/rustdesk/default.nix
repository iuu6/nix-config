{ lib, pkgs, ... }:
{
  imports = [
    ./..
  ];

  # RustDesk 远程桌面：客户端 + root 常驻服务。
  # 服务必须以 root 运行，才能通过 /dev/uinput 创建虚拟键鼠；
  # 这是 RustDesk 在 Wayland 下能注入键盘/鼠标输入的前提。
  hardware.uinput.enable = true;

  environment.systemPackages = with pkgs; [
    rustdesk
  ];

  systemd.services.rustdesk = {
    description = "RustDesk remote desktop service";
    wantedBy = [ "multi-user.target" ];
    wants = [ "network-online.target" ];
    after = [ "network-online.target" ];
    # `rustdesk --service` 并不会自己处理被控连接：它需要把 `--server`
    # 以登录用户的身份拉起（通过 sudo），并用 sh/ps/loginctl 等命令探测
    # 当前会话。NixOS 给 systemd 服务的默认 PATH 只有
    # coreutils/findutils/grep/sed/systemd，缺少 sudo、sh、ps、awk，
    # 会导致 --server 永远启动失败，于是 RustDesk GUI 进程退化成自己充当
    # 被控端：输入走 RemoteDesktop portal（GNOME 每次连接都会弹共享确认），
    # 并且键盘注入不可靠。这里补齐这些命令。
    path = with pkgs; [
      bash
      sudo
      procps
      gawk
      which
      glibc.getent
      xrandr
    ];
    # --server 由 root 服务通过 sudo -E 拉起。NixOS 的 rustdesk wrapper 只
    # 设置了 gstreamer + gst-plugins-base 两个插件目录；Wayland 抓屏还需要
    # pipewiresrc（pipewire 包提供）和 gst-plugins-good。GUI 进程从登录
    # 会话继承了完整路径，所以 GUI 抓屏正常；而 --server 继承的是服务的
    # 环境，缺少这两个目录，会报 "Failed to create element from factory
    # name"，随后退化并报 "Failed to get capturer display info"。
    environment.GST_PLUGIN_SYSTEM_PATH_1_0 = lib.makeSearchPath "lib/gstreamer-1.0" (
      with pkgs;
      [
        gst_all_1.gstreamer.out
        gst_all_1.gst-plugins-base
        gst_all_1.gst-plugins-good
        pipewire
      ]
    );
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.rustdesk}/bin/rustdesk --service";
      Restart = "always";
      RestartSec = 5;
    };
  };
}
