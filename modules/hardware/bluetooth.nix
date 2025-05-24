{
  lib,
  config,
  ...
}: let
  cfg = config.kBluetooth;
in {
  options.kBluetooth = {
    enable = lib.mkEnableOption "enable bluetooth";
    applet = lib.mkEnableOption "enable bluetooth applet";
  };

  config = lib.mkIf cfg.enable {
    services = {
      blueman = {
        enable = cfg.applet;
      };
    };

    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = true;
        settings = {
          General = {
            Enable = "Source,Sink,Media,Socket";
            Experimental = true;
          };
        };
      };
    };
  };
}
