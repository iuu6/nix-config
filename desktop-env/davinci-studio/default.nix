{ inputs, lib, ... }:
let
  unfree-pkgs = import inputs.nixpkgs-unstable {
    system = "x86_64-linux";
    config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [ "davinci-resolve-studio" ];
  };
in
{
  environment.systemPackages = [
    unfree-pkgs.davinci-resolve-studio
  ];
}
