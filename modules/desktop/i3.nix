{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.ki3;
in {
  options.ki3 = {enable = lib.mkEnableOption "enable i3";};

  config = lib.mkIf cfg.enable {
    environment.pathsToLink = ["/libexec"];
    services = {
      xserver = {

        desktopManager = {xterm = {enable = false;};};
        displayManager = {defaultSession = "none+i3";};

        windowManager.i3 = {
          enable = true;
          extraPackages = [
            pkgs.dmenu # application launcher most people use
            pkgs.i3status # gives you the default i3 status bar
            pkgs.i3lock # default i3 screen locker
            pkgs.i3blocks # if you are planning on using i3blocks over i3status
          ];
        };
      };
    };
  };
}
