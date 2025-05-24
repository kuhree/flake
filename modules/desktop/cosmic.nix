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
    services.desktopManager.cosmic.enable = true;
  };
}
