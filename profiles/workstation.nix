{
  config,
  lib,
  pkgs,
  kPkgs,
  kVars,
  ...
}: let
  cfg = config.kWorkstation;
in {
  options.kWorkstation = {
    enable = lib.mkEnableOption "workstation setup";
    greetd = lib.mkEnableOption "greetd";
    hardware = {
      keyboard = lib.mkEnableOption "qmk/via for keyboard(s)";
      lid = lib.mkEnableOption "support for laptop lids";
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
    ../modules/apps/firefox.nix
    ../modules/apps/steam.nix
    ../modules/boot.nix
    ../modules/fonts.nix
    ../modules/hardware/audio.nix
    ../modules/hardware/bluetooth.nix
    ../modules/hardware/keyboard.nix
    ../modules/hardware/intel.nix
    ../modules/hardware/lid.nix
    ../modules/hardware/nvidia.nix
    ../modules/locale.nix
    ../modules/networking.nix
    ../modules/nix.nix
    ../modules/security.nix
    ../modules/shell.nix
    ../modules/user.nix
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

    kIntelDrivers = {enable = cfg.hardware.intel;};
    kKeyboard = {enable = cfg.hardware.keyboard;};
    kLid = {enable = cfg.hardware.lid;};
    kNvidiaDrivers = {enable = cfg.hardware.nvidia;};

    kQEMU = {enable = cfg.virtualization.qemu;};
    kDocker = {enable = cfg.virtualization.docker;};

    kFirefox = {enable = cfg.extras.enable;};
    kSteam = {enable = cfg.extras.enable;};

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
      libinput = {enable = true;}; # Touchpad
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

      greetd = {
        enable = cfg.greetd; # Enable the greetd desktopManager
        vt = 3;
        settings = {
          default_session = {
            user = kVars.username;
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd '${pkgs.uwsm}/bin/uwsm start default'";
          };
        };
      };
    };

    environment.etc."greetd/environments".text = ''
      bash
      zsh
      uwsm
    '';

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
