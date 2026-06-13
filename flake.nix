{
  description = "Aura's NixOS configurations";

  nixConfig = {
    extra-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
    extra-trusted-substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      hosts = [
        "aura-latitude-5420"
        "aura-main-server"
      ];
      mkHost =
        name:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ (./server + "/${name}") ];
        };
    in
    {
      nixosConfigurations = nixpkgs.lib.genAttrs hosts mkHost;

      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-rfc-style;
    };
}
