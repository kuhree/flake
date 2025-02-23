{
  lib,
  config,
  ...
}: let
  cfg = config.kLid;
in {
  options.kLid = {enable = lib.mkEnableOption "enable kLid";};

  config = lib.mkIf cfg.enable {
    services = {
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
