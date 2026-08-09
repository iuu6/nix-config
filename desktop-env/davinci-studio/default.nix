{ inputs, ... }:
{
  environment.systemPackages = [
    inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.davinci-resolve-studio
  ];
}
