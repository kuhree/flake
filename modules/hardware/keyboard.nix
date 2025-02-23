{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kKeyboard;
in {
  options.kKeyboard = {
    enable = lib.mkEnableOption "enable qmk/via controls";
  };

  config = lib.mkIf cfg.enable {
    hardware = {keyboard = {qmk = {enable = true;};};};

    services = {
      udev = {
        enable = true;
        packages = [pkgs.via];
      };
    };
  };
}
