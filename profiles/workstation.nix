{
  config,
  lib,
  pkgs,
  kPkgs,
  ...
}: let
  cfg = config.kWorkstation;
in {
  options.kWorkstation = {
    enable = lib.mkEnableOption "workstation setup";

    hostname = lib.mkOption {
      default = "nixos";
      example = "thinkpad";
      description = "the hostname of the device";
      type = lib.types.str;
    };

    login = lib.mkOption {
      default = "greetd";
      example = "greetd";
      description = "the display manager to use (greetd/gdm/lightdm/sddm)";
      type = lib.types.enum ["greetd" "gdm" "lightdm" "sddm"];
    };

    desktop = lib.mkOption {
      default = "gnome";
      example = "gnome";
      description = "the desktop to use (greetd/gdm/lightdm/sddm)";
      type = lib.types.enum ["gnome" "i3" "hyprland"];
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

    extras = {enable = lib.mkEnableOption "extra apps, config, spicy stuff";};
  };

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
    ../modules/hardware/audio.nix
    ../modules/hardware/bluetooth.nix
    ../modules/hardware/intel.nix
    ../modules/hardware/keyboard.nix
    ../modules/hardware/laptop.nix
    ../modules/hardware/nvidia.nix
    ../modules/virtualization/docker.nix
    ../modules/virtualization/qemu.nix
  ];

  config = lib.mkIf cfg.enable {
    kAudio = {enable = cfg.enable;};
    kBluetooth = {enable = cfg.enable;};
    kBoot = {enable = cfg.enable;};
    kFonts = {enable = cfg.enable;};
    kLocale = {enable = cfg.enable;};
    kNet = {enable = cfg.enable;};
    kNix = {enable = cfg.enable;};
    kSecurity = {enable = cfg.enable;};
    kShell = {enable = cfg.enable;};
    kUser = {enable = cfg.enable;};

    # Drivers
    kIntelDrivers = {enable = cfg.hardware.intel;};
    kKeyboard = {enable = cfg.hardware.keyboard;};
    kLaptop = {enable = cfg.hardware.laptop;};
    kNvidiaDrivers = {enable = cfg.hardware.nvidia;};

    # Virtualization
    kQEMU = {enable = cfg.virtualization.qemu;};
    kDocker = {enable = cfg.virtualization.docker;};

    # Extras
    kFirefox = {enable = cfg.extras.enable;};
    kSteam = {enable = cfg.extras.enable;};

    # Desktops
    kGnome = {enable = cfg.desktop == "gnome";};
    ki3 = {enable = cfg.desktop == "i3";};
    kHyprland = {enable = cfg.desktop == "hyprland";};

    networking.hostName = cfg.hostname;
    boot = {
      # This is for OBS Virtual Cam Support
      kernelModules = ["v4l2loopback"];
      extraModulePackages = [config.boot.kernelPackages.v4l2loopback];

      # Appimage Support
      binfmt.registrations.appimage = {
        wrapInterpreterInShell = false;
        interpreter = "${pkgs.appimage-run}/bin/appimage-run";
        recognitionType = "magic";
        offset = 0;
        mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
        magicOrExtension = "\\x7fELF....AI\\x02";
      };
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
      dbus = {enable = true;};
      envfs = {enable = true;};
      flatpak = {enable = false;};
      gvfs = {enable = true;};
      nfs = {server = {enable = false;};};
      rpcbind = {enable = false;};
      tumbler = {enable = true;};
      upower = {enable = true;};
      udev = {enable = true;};

      gnome = {
        sushi = {enable = true;};
        gnome-keyring = {enable = true;};
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
        displayManager = {
          gdm.enable = cfg.login == "gdm";
          lightdm.enable = cfg.login == "lightdm";
        };
      };

      displayManager = {
        sddm.enable = cfg.login == "sddm";
      };

      greetd = {
        enable = cfg.login == "greetd";
        vt = 3;
      };
    };

    programs = {
      mtr = {enable = true;};
      nm-applet = {indicator = true;};
      thunar = {
        enable = true;
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
