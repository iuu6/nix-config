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
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # GNOME's own gcr-ssh-agent competes with gpg-agent's SSH support
  # (programs.gnupg.agent.enableSSHSupport in server/default.nix) for
  # SSH_AUTH_SOCK, and wins for GUI-launched apps (e.g. VS Code) since it
  # overrides the session env after login. Disable it so gpg-agent stays
  # the sole SSH agent.
  services.gnome.gcr-ssh-agent.enable = false;

  # Enable fcitx5 autostart for GNOME.
  # gnome-remote-desktop also goes here: the GNOME module prepends each
  # sessionPath package's share/gsettings-schemas/<name> to XDG_DATA_DIRS,
  # which is required by the Settings "Remote Desktop" page
  # (org.gnome.desktop.remote-desktop.rdp schema). Without it the page
  # cannot be opened even when it is visible.
  services.desktopManager.gnome.sessionPath = [
    config.i18n.inputMethod.package
    pkgs.gnome-remote-desktop
  ];

  # GNOME 50's Settings only shows System → Remote Desktop when the
  # system-level gnome-remote-desktop.service is "enabled" or "disabled".
  # NixOS installs the unit via systemd.packages as a plain symlink, so
  # systemd reports it as "linked" and Settings hides the page entirely.
  # Enabling it (the upstream default via [Install] WantedBy) makes the
  # page appear.
  systemd.services."gnome-remote-desktop".wantedBy = [ "graphical.target" ];

  # The Settings "Remote Login" switch makes the configuration daemon enable
  # the system unit via pkexec. Two NixOS-specific issues have to be worked
  # around here:
  #  1. system services inherit systemd's ManagerEnvironment PATH, which does
  #     not contain /run/wrappers/bin, so pkexec was not found.
  #  2. systemd sets SHELL to the user's nologin, but pkexec rejects a $SHELL
  #     that is not listed in /etc/shells. Override it with a valid shell.
  systemd.services."gnome-remote-desktop-configuration".environment = {
    PATH = lib.mkForce "/run/wrappers/bin:${config.system.path}/bin";
    SHELL = "/run/current-system/sw/bin/bash";
  };

  # Install GNOME extensions for system tray support and tiling window management
  environment.systemPackages = with pkgs; [
    gnomeExtensions.appindicator
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.paperwm
    gnomeExtensions.system-monitor-next
    gnomeExtensions.brightness-control-using-ddcutil
  ];

  # Fix window buttons layout to include minimize and maximize buttons
  # and enable AppIndicator/KStatusNotifierItem support extension
  programs.dconf.profiles.user.databases = [
    {
      settings = {
        "org/gnome/desktop/wm/preferences" = {
          button-layout = "appmenu:minimize,maximize,close";
        };
        "org/gnome/shell" = {
          enabled-extensions = [
            "appindicatorsupport@rgcjonas.gmail.com"
            "trayIconsReloaded@selfmade.pl"
            "paperwm@paperwm.github.com"
            "system-monitor-next@paradoxxx.zero.gmail.com"
            "kimpanel@kde.org"
            "display-brightness-ddcutil@themightydeity.github.com"
          ];
        };
        # Free up keybindings that conflict with PaperWM
        "org/gnome/desktop/wm/keybindings" = {
          move-to-monitor-left = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          move-to-monitor-right = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          move-to-monitor-up = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          move-to-monitor-down = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          maximize = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          unmaximize = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
        };
        "org/gnome/mutter/keybindings" = {
          toggle-tiled-left = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
          toggle-tiled-right = lib.gvariant.mkEmptyArray lib.gvariant.type.string;
        };
        # GNOME 50 raises the screen shield on idle even with lock-enabled
        # false, which switches to the "unlock-dialog" session mode and makes
        # mutter inhibit remote access ("Session creation inhibited" for GNOME
        # RDP). Disable idle blanking entirely so RDP stays available; power
        # the monitor off manually if needed.
        "org/gnome/desktop/session" = {
          idle-delay = lib.gvariant.mkUint32 0;
        };
        "org/gnome/desktop/screensaver" = {
          lock-enabled = false;
          idle-activation-enabled = false;
        };
        "org/gnome/settings-daemon/plugins/power" = {
          # Idle suspend would also make SSH/RDP unreachable.
          sleep-inactive-ac-type = "nothing";
          sleep-inactive-battery-type = "nothing";
          sleep-inactive-ac-timeout = lib.gvariant.mkInt32 3600;
          sleep-inactive-battery-timeout = lib.gvariant.mkInt32 3600;
        };
      };
    }
  ];
}
