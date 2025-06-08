{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kGnome;
in {
  options.kGnome = {
    enable = lib.mkEnableOption "enable gnome";
  };

  config = lib.mkIf cfg.enable {
    services = {
      desktopManager.gnome.enable = true;
      gnome.core-apps.enable = true;
    };

    environment.systemPackages = [
      pkgs.gnome-tweaks
    ];

    programs.dconf.enable = true;
  };
}
