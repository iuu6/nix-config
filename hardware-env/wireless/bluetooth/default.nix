{ config, pkgs, ... }:
{
  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true;

  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };

  services.pulseaudio.extraConfig = "
  load-module module-switch-on-connect
    ";

  services.blueman.enable = true;

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  #   I don't know what is does but I use fish ,so skip it
  #   programs.bash.shellAliases = {
  #     mixer = "pulsemixer";
  #   };
  environment.systemPackages = with pkgs; [

    pulseaudioFull
    # Console mixer
    pulsemixer

    # Equalizer on sterids
    easyeffects
  ];
}
