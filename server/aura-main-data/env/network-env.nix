{ pkgs, ... }:
{
  imports = [  ];

  # 固定 IP。原先走 DHCP，这里照抄其租约值，IP/网关/DNS 全部不变。
  networking.networkmanager.ensureProfiles.profiles.ens160-static = {
    connection = {
      id = "ens160-static";
      type = "ethernet";
      interface-name = "ens160";
      autoconnect = "true";
      autoconnect-priority = "100";
    };
    ipv4 = {
      method = "manual";
      address1 = "10.59.73.126/24,10.59.73.1";
      dns = "223.5.5.5;";
    };
  };

  # 时序补丁：NetworkManager-ensure-profiles.service 是在 NM 启动「之后」
  # 才写 profile 的，而 NM 在网卡一出现时就抢先按 DHCP profile 连上了
  # （实测差 6 秒）。nmcli connection reload 不会切已激活的连接。
  # 故在此显式切一次；失败则保持现状，DHCP profile 仍保留兜底。
  systemd.services.ens160-static-activate = {
    description = "Activate static IP profile on ens160";
    after = [ "NetworkManager.service" "NetworkManager-ensure-profiles.service" ];
    requires = [ "NetworkManager-ensure-profiles.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if ! ${pkgs.networkmanager}/bin/nmcli -t -f NAME connection show --active | grep -qx ens160-static; then
        ${pkgs.networkmanager}/bin/nmcli connection up ens160-static || true
      fi
    '';
  };
}
