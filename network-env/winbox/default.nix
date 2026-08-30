{ pkgs, ... }:
{
  imports = [
    ./..
  ];

  environment.systemPackages = [
    pkgs.winbox4
  ];

  # 放行RouterOS邻居发现协议(MNDP)广播，否则WinBox的Neighbors列表收不到设备
  networking.firewall.allowedUDPPorts = [ 5678 ];
  # 临时开日志，排查MAC连接被拒绝的具体端口，排查完可以关掉
  networking.firewall.logRefusedPackets = true;
  # RouterOS的MAC-Telnet/MAC连接协议回包用固定源端口20561、随机目的端口，
  # 且IP层是0.0.0.0->255.255.255.255，conntrack认不出属于已建立连接，需按源端口单独放行
  networking.firewall.extraCommands = ''
    iptables -A nixos-fw -p udp --sport 20561 -j nixos-fw-accept
  '';

  # MAC连接需要发原始以太网帧(AF_PACKET)，普通用户没有CAP_NET_RAW权限会导致连接超时
  security.wrappers.WinBox = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_raw+ep";
    source = "${pkgs.winbox4}/bin/.WinBox-wrapped";
  };
}
