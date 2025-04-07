{
  lib,
  config,
  pkgs,
  inputs,
  system,
  kPkgs,
  kVars,
  ...
}: let
  cfg = config.kHyprland;
in {
  options.kHyprland = {
		enable = lib.mkEnableOption "enable hyprland";
		greetd = lib.mkEnableOption "enable greetd display manager";
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

      systemPackages = kPkgs.wayland ++ kPkgs.hyprland;
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        package = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system}.mesa;
        package32 = inputs.hyprland.inputs.nixpkgs.legacyPackages.${system}.pkgsi686Linux.mesa;
      };
    };

    programs = {
      hyprlock = {enable = true;};
      hyprland = {
        enable = true; # Install hyprland
        withUWSM = true; # Systemd-based session
        package = inputs.hyprland.packages.${system}.hyprland.override {
          enableXWayland = true;
          legacyRenderer = false; # Enable for older GPUs
          withSystemd = true;
        };

        portalPackage =
          inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;

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
