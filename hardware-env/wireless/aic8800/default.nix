{
  config,
  pkgs,
  ...
}:
let
  # legacy-mcu1: matched firmware/loader profile for devices reporting
  # chip_mcu_id=1 (e.g. this UGREEN adapter). The main branch fails to upload
  # firmware on those revisions.
  src = pkgs.fetchFromGitHub {
    owner = "shenmintao";
    repo = "aic8800d80";
    rev = "cc12692ed08d2175e0072e387b6dd1f1d46abec5";
    hash = "sha256-bFj2Zxp3+NDiSrBu3lCEFi8V6IMS4cvEJAGYVgkN7FU=";
  };

  # Uncompressed firmware tree. The driver opens these files directly with
  # filp_open(), so it cannot use the zstd-compressed copy that NixOS puts in
  # /run/current-system/firmware.
  firmware = pkgs.runCommand "aic8800-firmware" { } ''
    mkdir -p "$out/lib/firmware"
    cp -r ${src}/fw/aic8800* "$out/lib/firmware/"
  '';

  aic8800 = config.boot.kernelPackages.callPackage ./package.nix {
    inherit src;
    firmwarePath = "${firmware}/lib/firmware";
  };
in
{
  boot.extraModulePackages = [ aic8800 ];
  # aic8800_fdrv depends on aic_load_fw, which uploads the firmware.
  boot.kernelModules = [ "aic8800_fdrv" ];

  # Still expose the firmware through the normal kernel path for the parts of
  # the driver that use request_firmware().
  hardware.firmware = [ firmware ];
}
