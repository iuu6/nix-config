{ pkgs, ... }:
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
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.rustdesk}/bin/rustdesk --service";
      Restart = "always";
      RestartSec = 5;
    };
  };
}
