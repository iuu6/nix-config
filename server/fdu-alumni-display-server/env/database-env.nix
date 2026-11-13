{ pkgs, ... }:
{
  imports = [
    # MongoDB 客户端工具（mongosh、mongodump/mongorestore 等）
    ./../../../code-editor-env/mongodb
  ];

  services.mongodb = {
    enable = true;

    # pkgs.mongodb 需要从源码构建且为 unfree，不在 cache.nixos.org 上；
    # mongodb-ce 是同样的服务端，以预编译二进制形式提供。
    package = pkgs.mongodb-ce;

    # 仅监听本机，通过 SSH 隧道访问。
    bind_ip = "127.0.0.1";

    # 本机没有独立数据盘，使用模块默认的 /var/db/mongodb。
  };
}
