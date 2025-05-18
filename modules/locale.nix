{
  lib,
  config,
  ...
}: let
  cfg = config.kLocale;
in {
  options.kLocale = {
    enable = lib.mkEnableOption "enable locale";
    locale = lib.mkOption {
      default = "en_US.UTF-8";
      example = "en_US.UTF-8";
      description = "the primary locale for the device";
      type = lib.types.str;
    };

    timezone = lib.mkOption {
      default = "America/New_York";
      example = "America/New_York";
      description = "the primary timezone for the device";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    time = {timeZone = cfg.timezone;};

    i18n = {
      defaultLocale = cfg.locale;

      extraLocaleSettings = {
        LL_ALL = "C";
        LC_ADDRESS = cfg.locale;
        LC_IDENTIFICATION = cfg.locale;
        LC_MEASUREMENT = cfg.locale;
        LC_MONETARY = cfg.locale;
        LC_NAME = cfg.locale;
        LC_NUMERIC = cfg.locale;
        LC_PAPER = cfg.locale;
        LC_TELEPHONE = cfg.locale;
        LC_TIME = cfg.locale;
      };
    };

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };
  };
}
