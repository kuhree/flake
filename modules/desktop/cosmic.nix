{
  lib,
  config,
  ...
}: let
  cfg = config.kCosmic;
in {
  options.kCosmic = {
    enable = lib.mkEnableOption "enable cosmic";
  };

  config = lib.mkIf cfg.enable {
    services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;
  };
}
