{
  description = "Aura's desktop env";

  nixConfig.trusted-substituters = [
    "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=1"
    "https://cache.nixos.org?priority=10"
  ];
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  };

  outputs =
    { nixpkgs, ... }@inputs:
    {
      nixosConfigurations = {
        aura-latitude-5420 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";     
          modules = with inputs; [
            ./server/aura-latitude-5420
            ./desktop-env/kde-plasma
            ./code-editor-env/vscode
            ./code-editor-env/navicat-premium

            # flake-programs-sqlite.nixosModules.programs-sqlite
            # { system.configurationRevision = self.rev or "dirty"; }
          ];
          specialArgs = {
            inherit inputs;
          };
        };
      };
    };
}