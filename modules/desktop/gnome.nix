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
        displayManager.gdm.enable = true; # Enable the gnome desktopManager
        desktopManager.gnome = {
          enable = true; # Enable the GNOME Desktop Environment.
        };
      };

      gnome = {gnome-keyring = {enable = true;};};
    };

    environment = {systemPackages = kPkgs.gnome;};
  };
}
