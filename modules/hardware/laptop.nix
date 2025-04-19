{
  lib,
  config,
  ...
}: let
  cfg = config.kLaptop;
in {
  options.kLaptop = {enable = lib.mkEnableOption "enable laptop (lid/touchpad)";};

  config = lib.mkIf cfg.enable {
    services = {
      libinput = {enable = true;}; # Touchpad
      logind = {
        lidSwitch = "suspend";
        lidSwitchExternalPower = "suspend";
        extraConfig = ''
          HandlePowerKey=suspend
          HibernateDelaySec=3600
        '';
      };
    };
  };
}
