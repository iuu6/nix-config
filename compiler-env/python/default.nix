{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  sdlLibs = with pkgs; [ SDL2 SDL2_mixer SDL2_image SDL2_ttf freetype xorg.libX11 ];
in
{
  imports = [
    ./..
  ];
  environment.systemPackages = with pkgs; sdlLibs ++ [ uv pkg-config ];

  environment.sessionVariables = {
    LD_LIBRARY_PATH = lib.makeLibraryPath sdlLibs;
  };
}
