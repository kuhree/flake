{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kHyprland;
in {
  options.kHyprland = {
    enable = lib.mkEnableOption "enable hyprland";
    username = lib.mkOption {
      default = "kuhree";
      example = "kuhree";
      description = "the username for the primary user";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    # Extra Portal Configuration
    xdg.portal = {
      enable = true;
      wlr.enable = false;
      config.common.default = "*";
      extraPortals = [pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-gtk];
      configPackages = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal];
    };

    services = {
      xserver = {
        enable = false; # Disable X11 in favor of wayland
      };

      greetd = {
        settings = {
          default_session = {
            user = cfg.username;
            command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --cmd '${pkgs.uwsm}/bin/uwsm start default'";
          };
        };
      };
    };

    nix = {
      settings = {
        substituters = [
          "https://hyprland.cachix.org"
        ];
      };
    };

    environment = {
      sessionVariables = {
        CLUTTER_BACKEND = "wayland";
        GTK_USE_PORTAL = "1";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1"; # force electron -> wayland
        NIXOS_XDG_OPEN_USE_PORTAL = "1";
        SDL_VIDEODRIVER = "wayland,x11";
        WLR_NO_HARDWARE_CURSORS = "1";
        XCURSOR_SIZE = "24";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
      };

      etc."greetd/environments".text = ''
        bash
        zsh
        uwsm
      '';

      systemPackages = [
        pkgs.hyprcursor
        pkgs.hypridle
        pkgs.hyprland-protocols
        pkgs.hyprpicker
        pkgs.rofi-wayland
        pkgs.mako
        pkgs.swww
        pkgs.wlogout
        pkgs.wlr-randr
        pkgs.wlsunset
        pkgs.udiskie
        # clipboard
        pkgs.cliphist
        pkgs.wl-clipboard
        # scrot
        pkgs.grim
        pkgs.grimblast
        pkgs.slurp
        pkgs.swappy
      ];
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;

        # If using the flake
        # package = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.mesa;
        # package32 = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.system}.pkgsi686Linux.mesa;
      };
    };

    programs = {
      hyprlock = {enable = true;};
      hyprland = {
        enable = true; # Install hyprland
        withUWSM = true; # Systemd-based session

        # Uses Hyprland Flake
        # package = inputs.hyprland.packages.${pkgs.system}.hyprland.override {
        #   enableXWayland = true;
        #   legacyRenderer = false; # Enable for older GPUs
        #   withSystemd = true;
        # };
        # Keeps Hyprland flake & portal pkgs in sync
        # portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;

        xwayland = {
          enable = true;
        };
      };

      waybar = {
        enable = true;
        package = pkgs.waybar;
      };
    };
  };
}
