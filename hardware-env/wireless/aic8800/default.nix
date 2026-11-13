{
  config,
  lib,
  pkgs,
  ...
}:
let
  # AIC8800 (a69c:8d80, used by e.g. UGREEN AX900 USB adapters) has no
  # in-tree Linux driver, so build the out-of-tree module for the running
  # kernel.
  aic8800 = config.boot.kernelPackages.callPackage ./package.nix { };

  # Firmware must live under /lib/firmware/aic8800*. The driver probes the
  # chip revision and picks the matching directory itself.
  firmware = pkgs.runCommand "aic8800-firmware" { } ''
    mkdir -p "$out/lib/firmware"
    cp -r ${aic8800.src}/fw/aic8800* "$out/lib/firmware/"
  '';
in
{
  boot.extraModulePackages = [ aic8800 ];
  # aic8800_fdrv depends on aic_load_fw, which uploads the firmware.
  boot.kernelModules = [ "aic8800_fdrv" ];

  hardware.firmware = [ firmware ];

  # The adapter does not need the usb_modeswitch rules from upstream aic.rules:
  # it already enumerates as a69c:8d80 instead of a mass-storage id.
}
