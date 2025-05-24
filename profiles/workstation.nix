{
  config,
  lib,
  pkgs,
  kPkgs,
  ...
}: let
  cfg = config.kWorkstation;

  # If true, adds sys tray applets.
  hasCustomTray = cfg.desktop != "cosmic" && cfg.desktop != "gnome";
in {
  imports = [
    ../modules/boot.nix
    ../modules/fonts.nix
    ../modules/locale.nix
    ../modules/networking.nix
    ../modules/nix.nix
    ../modules/security.nix
    ../modules/shell.nix
    ../modules/user.nix
    ../modules/apps/firefox.nix
    ../modules/apps/steam.nix
    ../modules/desktop/gnome.nix
    ../modules/desktop/hyprland.nix
    ../modules/desktop/i3.nix
    ../modules/desktop/cosmic.nix
    ../modules/hardware/audio.nix
    ../modules/hardware/bluetooth.nix
    ../modules/hardware/intel.nix
    ../modules/hardware/keyboard.nix
    ../modules/hardware/laptop.nix
    ../modules/hardware/nvidia.nix
    ../modules/virtualization/docker.nix
    ../modules/virtualization/qemu.nix
  ];

  options.kWorkstation = {
    enable = lib.mkEnableOption "workstation setup";

    username = lib.mkOption {
      default = "kuhree";
      example = "kuhree";
      description = "the username for the primary user";
      type = lib.types.str;
    };

    locale = lib.mkOption {
      default = "en_US.UTF-8";
      example = "en_US.UTF-8";
      description = "the primary locale for the device";
      type = lib.types.str;
    };

    timezone = lib.mkOption {
      default = "America/New_York";
      example = "America/New_York";
      description = "the primary timezone for the device";
      type = lib.types.str;
    };

    hostname = lib.mkOption {
      default = "nixos";
      example = "nixos";
      description = "the hostname of the device";
      type = lib.types.str;
    };

    login = lib.mkOption {
      default = "greetd";
      example = "greetd";
      description = "the display manager to use (greetd/gdm/lightdm/sddm/cosmic)";
      type = lib.types.enum ["greetd" "gdm" "lightdm" "sddm" "cosmic"];
    };

    desktop = lib.mkOption {
      default = "gnome";
      example = "gnome";
      description = "the desktop to use (gnome/i3/hyprland/cosmic)";
      type = lib.types.enum ["gnome" "i3" "hyprland" "cosmic"];
    };

    hardware = {
      keyboard = lib.mkEnableOption "qmk/via for keyboard(s)";
      laptop = lib.mkEnableOption "support for laptops";
      nvidia = lib.mkEnableOption "nvidia drivers";
      intel = lib.mkEnableOption "intel drivers";
    };

    virtualization = {
      qemu = lib.mkEnableOption "qemu host";
      docker = lib.mkEnableOption "docker host";
    };

    extras = {
      enable = lib.mkEnableOption "extra apps, config, spicy stuff";
    };
  };

  config = lib.mkIf cfg.enable {
    kAudio.enable = cfg.enable;
    kBluetooth = {
      enable = cfg.enable;
      applet = hasCustomTray;
    };
    kBoot.enable = cfg.enable;
    kFonts.enable = cfg.enable;
    kNix.enable = cfg.enable;
    kSecurity.enable = cfg.enable;
    kShell.enable = cfg.enable;
    kUser = {
      enable = cfg.enable;
      username = cfg.username;
    };
    kLocale = {
      enable = cfg.enable;
      timezone = cfg.timezone;
      locale = cfg.locale;
    };
    kNet = {
      enable = cfg.enable;
      hostname = cfg.hostname;
    };

    # Drivers
    kIntelDrivers.enable = cfg.hardware.intel;
    kKeyboard.enable = cfg.hardware.keyboard;
    kLaptop.enable = cfg.hardware.laptop;
    kNvidiaDrivers.enable = cfg.hardware.nvidia;

    # Virtualization
    kQEMU.enable = cfg.virtualization.qemu;
    kDocker.enable = cfg.virtualization.docker;

    # Extras
    kFirefox.enable = cfg.extras.enable;
    kSteam = {
      enable = cfg.extras.enable;
      username = cfg.username;
    };

    # Desktops
    kCosmic.enable = cfg.desktop == "cosmic";
    kGnome.enable = cfg.desktop == "gnome";
    ki3.enable = cfg.desktop == "i3";
    kHyprland = {
      enable = cfg.desktop == "hyprland";
      username = cfg.username;
    };

    boot = {
      # This is for OBS Virtual Cam Support
      kernelModules = ["v4l2loopback"];
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
    };

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-gtk];
      configPackages = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal];
    };

    systemd = {
      services = {
        seatd = {
          enable = true;
          description = "Seat management daemon";
          script = "${pkgs.seatd}/bin/seatd -g wheel";
          serviceConfig = {
            Type = "simple";
            Restart = "always";
            RestartSec = "1";
          };
          wantedBy = ["multi-user.target"];
        };
      };
    };

    services = {
      dbus.enable = true;
      envfs.enable = true;
      gvfs.enable = true;
      tumbler.enable = true;
      upower.enable = true;
      udev.enable = true;

      gnome = {
        sushi.enable = true;
        gnome-keyring.enable = true;
      };

      smartd = {
        enable = true;
        autodetect = true;
      };

      fstrim = {
        enable = true;
        interval = "weekly";
      };

      xserver = {
        enable = cfg.login == "gdm" || cfg.login == "lightdm";
        displayManager = {
          gdm.enable = cfg.login == "gdm";
          lightdm.enable = cfg.login == "lightdm";
        };
      };

      displayManager = {
        sddm.enable = cfg.login == "sddm";
        cosmic-greeter.enable = cfg.login == "cosmic";
      };

      greetd = {
        enable = cfg.login == "greetd";
        vt = 3;
      };
    };

    programs = {
      appimage.enable = true;
      mtr.enable = true;
      nm-applet.indicator = hasCustomTray;
      thunar = {
        enable = hasCustomTray;
        plugins = [
          pkgs.xfce.exo
          pkgs.xfce.mousepad
          pkgs.xfce.thunar-archive-plugin
          pkgs.xfce.thunar-volman
          pkgs.xfce.tumbler
        ];
      };
    };

    environment = {
      sessionVariables = {
        GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas";
      };

      systemPackages = kPkgs.gui ++ kPkgs.utils ++ kPkgs.gtk ++ kPkgs.qt;
    };

    # Security / Polkit
    security = {
      polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (
            subject.isInGroup("users")
              && (
                action.id == "org.freedesktop.login1.reboot" ||
                action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
                action.id == "org.freedesktop.login1.power-off" ||
                action.id == "org.freedesktop.login1.power-off-multiple-sessions"
              )
            )
          {
            return polkit.Result.YES;
          }
        })
      '';
    };
  };
}
