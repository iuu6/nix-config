{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ./..
  ];

  programs.clash-verge = {
    enable = true;
    package = pkgs.clash-verge-rev;
    autoStart = false;
    serviceMode = true;
    tunMode = true;
  };

  # TUN mode requires IP forwarding to route traffic through the virtual interface
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  # Trust the mihomo TUN interface (default name "Meta") so firewall doesn't block forwarded packets
  networking.firewall.trustedInterfaces = [ "Meta" ];
}
