{ pkgs, ... }:
{
  services.mongodb = {
    enable = true;

    # pkgs.mongodb is built from source and is unfree, so it is not on
    # cache.nixos.org; mongodb-ce is the same server as a prebuilt binary.
    package = pkgs.mongodb-ce;

    # localhost only, no authentication: reach it over SSH or a tunnel
    bind_ip = "127.0.0.1";

    # z4g4's dedicated data disk.
    # NOTE: /data is mounted with `nofail`, so if that disk is missing at boot
    # mongod would silently create the dbpath on the root filesystem instead.
    dbpath = "/data/mongodb";
  };
}
