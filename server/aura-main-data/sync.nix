{ pkgs, ... }:
let
  mkSync =
    {
      name,
      src,
      dst,
    }:
    pkgs.writeShellScript "mirror-${name}" ''
      set -euo pipefail

      # 安全护栏：必须是真实挂载点，否则 rsync 会写进根盘空目录
      if ! ${pkgs.util-linux}/bin/mountpoint -q /mnt/main-data; then
        echo "[mirror-${name}] 错误: /mnt/main-data 未挂载，中止" >&2
        exit 1
      fi
      if ! ${pkgs.util-linux}/bin/mountpoint -q /mnt/core-data; then
        echo "[mirror-${name}] 错误: /mnt/core-data 未挂载，中止" >&2
        exit 1
      fi

      echo "[mirror-${name}] 开始同步: ${src} -> ${dst}"
      ${pkgs.rsync}/bin/rsync \
        --archive --hard-links --numeric-ids --delete --partial --info=stats2 \
        "${src}" "${dst}"
      echo "[mirror-${name}] 同步完成"
    '';

  mkService =
    {
      name,
      src,
      dst,
      desc,
    }:
    {
      description = desc;
      unitConfig = {
        ConditionPathIsMountPoint = [
          "/mnt/main-data"
          "/mnt/core-data"
        ];
        RequiresMountsFor = [
          "/mnt/main-data"
          "/mnt/core-data"
        ];
      };
      serviceConfig = {
        Type = "oneshot";
        Nice = 19;
        IOSchedulingClass = "idle";
        ExecStart = mkSync { inherit name src dst; };
      };
    };

  mkTimer = _name: {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:30:00";
      Persistent = true;
      RandomizedDelaySec = "10m";
    };
  };
in
{
  # core-data: 纯数据，在线同步即可
  systemd.services.mirror-core-data = mkService {
    name = "core-data";
    src = "/mnt/main-data/core-data/";
    dst = "/mnt/core-data/core-data/";
    desc = "Mirror main-data/core-data to core-data/core-data";
  };

  # docker: 不停止容器（按要求），数据库副本可能瞬时不一致，下次同步会自动修正
  systemd.services.mirror-docker = mkService {
    name = "docker";
    src = "/mnt/main-data/docker/";
    dst = "/mnt/core-data/docker/";
    desc = "Mirror main-data/docker to core-data/docker (containers keep running)";
  };

  systemd.timers.mirror-core-data = mkTimer "core-data";
  systemd.timers.mirror-docker = mkTimer "docker";
}
