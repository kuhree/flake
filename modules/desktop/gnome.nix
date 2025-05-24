{
  lib,
  config,
  kPkgs,
  ...
}: let
  cfg = config.kGnome;
in {
  options.kGnome = {
    enable = lib.mkEnableOption "enable gnome";
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver = {
        desktopManager.gnome = {
          enable = true;
        };
      };

      gnome = {
        core-apps.enable = true;
        gnome-keyring.enable = true;
      };
    };

    environment = {
      systemPackages = kPkgs.gnome;
    };

    programs = {
      dconf = {
        enable = true;
      };
    };
  };
}
