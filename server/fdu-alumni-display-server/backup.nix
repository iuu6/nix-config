{ pkgs, ... }:
let
  # 备份脚本：镜像同步 4 个目录 + MongoDB 全量 dump 到 /mnt/data/backup。
  # 可通过 `sudo backup-home` 手动执行，也由 systemd timer 每天自动运行。
  backup-home = pkgs.writeShellApplication {
    name = "backup-home";
    runtimeInputs = with pkgs; [
      rsync
      util-linux
      coreutils
      findutils
      mongodb-tools
    ];
    text = ''
      set -euo pipefail

      # 防止手动执行与定时任务并发写同一个目标目录
      if [ -z "''${BACKUP_HOME_LOCKED:-}" ]; then
        export BACKUP_HOME_LOCKED=1
        exec flock -n /run/lock/backup-home.lock "$0" "$@"
      fi

      DEST=/mnt/data/backup
      MONGODIR="$DEST/mongodb"
      KEEP_MONGO=7

      # 安全护栏：/mnt/data 是 nofail 挂载，未挂载时绝不能往根盘的空目录里写
      if ! mountpoint -q /mnt/data; then
        echo "错误: /mnt/data 未挂载，中止备份" >&2
        exit 1
      fi

      mkdir -p "$DEST" "$MONGODIR"

      # 可重新生成的依赖/缓存不备份；.git 保留
      EXCLUDES=(
        --exclude=node_modules/
        --exclude=.cache/
        --exclude=__pycache__/
      )

      for name in Data nix-config Old_Data Server; do
        src="/home/fdu-alumni/$name"
        if [ ! -d "$src" ]; then
          echo "==> 跳过不存在的目录: $src"
          continue
        fi
        echo "==> 同步 $src -> $DEST/$name"
        rsync \
          --archive --numeric-ids --delete --partial --info=stats2 \
          "''${EXCLUDES[@]}" \
          "$src/" "$DEST/$name/"
      done

      # MongoDB：全量 dump（所有数据库），保留最近 KEEP_MONGO 份。
      # 先写临时文件，成功后再原子改名：中途重启不会留下看似完整、实则损坏的备份。
      find "$MONGODIR" -maxdepth 1 -type f -name '.*.tmp' -delete

      STAMP="$(date +%Y%m%d-%H%M%S)"
      MONGO_TMP="$MONGODIR/.mongodb-$STAMP.archive.gz.tmp"
      MONGO_FILE="$MONGODIR/mongodb-$STAMP.archive.gz"
      trap 'rm -f "$MONGO_TMP"' EXIT
      echo "==> 备份 MongoDB -> $MONGO_FILE"
      mongodump --quiet --gzip --archive="$MONGO_TMP"
      mv "$MONGO_TMP" "$MONGO_FILE"
      trap - EXIT

      echo "==> 清理旧 MongoDB 备份（保留最近 $KEEP_MONGO 份）"
      find "$MONGODIR" -maxdepth 1 -type f -name 'mongodb-*.archive.gz' -printf '%T@ %p\n' \
        | sort -rn \
        | tail -n +$((KEEP_MONGO + 1)) \
        | cut -d' ' -f2- \
        | xargs -r rm -f

      echo "==> 备份完成: $DEST"
    '';
  };
in
{
  environment.systemPackages = [ backup-home ];

  systemd.services.backup-home = {
    description = "Backup /home/fdu-alumni directories and MongoDB to /mnt/data/backup";
    unitConfig = {
      ConditionPathIsMountPoint = "/mnt/data";
      RequiresMountsFor = "/mnt/data";
    };
    serviceConfig = {
      Type = "oneshot";
      Nice = 19;
      IOSchedulingClass = "idle";
      ExecStart = "${backup-home}/bin/backup-home";
    };
  };

  systemd.timers.backup-home = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Persistent = true;
      RandomizedDelaySec = "10m";
    };
  };
}
