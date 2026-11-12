{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    ./..
  ];
  environment.systemPackages = [
    # nixos-26.05 ships vscode 1.144.0 but still patches the pre-1.122 ripgrep
    # path, which no longer exists in the tarball.
    # https://github.com/NixOS/nixpkgs/issues/584492
    (pkgs.vscode.overrideAttrs (old: {
      postPatch = lib.replaceStrings
        [ "resources/app/node_modules/@vscode/ripgrep/bin/rg" ]
        [ "resources/app/node_modules/@vscode/ripgrep-universal/bin/linux-x64/rg" ]
        (old.postPatch or "");
    }))
  ];
}
