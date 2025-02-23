{
  lib,
  config,
  kVars,
  ...
}: let
  cfg = config.kLocale;
in {
  options.kLocale = {enable = lib.mkEnableOption "enable locale";};

  config = lib.mkIf cfg.enable {
    time = {timeZone = kVars.tz;};

    i18n = {
      defaultLocale = kVars.locale;

      extraLocaleSettings = {
        LC_ADDRESS = kVars.locale;
        LC_IDENTIFICATION = kVars.locale;
        LC_MEASUREMENT = kVars.locale;
        LC_MONETARY = kVars.locale;
        LC_NAME = kVars.locale;
        LC_NUMERIC = kVars.locale;
        LC_PAPER = kVars.locale;
        LC_TELEPHONE = kVars.locale;
        LC_TIME = kVars.locale;
      };
    };

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
