{ pkgs, ... }:
{
  # MongoDB client tooling (mongosh shell, mongodump/mongorestore/mongoexport, ...)
  environment.systemPackages = with pkgs; [
    mongodb-tools
    mongosh
  ];
}
