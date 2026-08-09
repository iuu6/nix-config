{ config, lib, ... }:
let
  davinci-path = ./../../../desktop-env/davinci-studio;
in
{
  imports = [
    ./../../../desktop-env/gnome
    ./../../../desktop-env/onlyoffice
  ] ++ lib.optionals (builtins.pathExists davinci-path) [
    davinci-path
  ];
}
