{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    just
    direnv
    devenv
    docker_29
  ];
}
