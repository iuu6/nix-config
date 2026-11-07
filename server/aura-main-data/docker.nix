{ ... }:
{
  # Docker 引擎（autoPrune 自动清理悬空镜像/停止的容器）
  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
  };

  # 允许 aura 用户直接使用 docker 命令
  users.users.aura.extraGroups = [ "docker" ];

  # 两个容器：MT Photos 照片管理、Vaultwarden 密码管理器
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      mtphotos = {
        image = "mtphotos/mt-photos:latest";
        ports = [ "8063:8063" ];
        volumes = [
          "/mnt/main-data/docker/mtphotos/config:/config"
          "/mnt/main-data/docker/mtphotos/upload:/upload"
          "/mnt/main-data/docker/mtphotos/photos:/photos"
        ];
        environment = {
          TZ = "Asia/Shanghai";
        };
        # 新版 nixpkgs 默认 autoRemoveOnStop = true（会加 --rm），与 --restart 冲突
        autoRemoveOnStop = false;
        extraOptions = [ "--restart=always" ];
      };

      vaultwarden = {
        image = "vaultwarden/server:latest";
        ports = [ "8081:80" ];
        volumes = [ "/mnt/main-data/docker/vw-data:/data" ];
        environment = {
          TZ = "Asia/Shanghai";
        };
        autoRemoveOnStop = false;
        extraOptions = [ "--restart=always" ];
      };
    };
  };

  # 数据在 /mnt/main-data 上，必须等挂载完成再启动
  systemd.services."docker-mtphotos".unitConfig.RequiresMountsFor = "/mnt/main-data/docker/mtphotos";
  systemd.services."docker-vaultwarden".unitConfig.RequiresMountsFor = "/mnt/main-data/docker/vw-data";

  networking.firewall.allowedTCPPorts = [ 8063 8081 ];
}
