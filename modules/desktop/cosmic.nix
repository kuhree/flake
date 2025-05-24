{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kCosmic;
in {
  options.kCosmic = {
    enable = lib.mkEnableOption "enable cosmic";
  };

  config = lib.mkIf cfg.enable {
    services.greetd.enable = lib.mkForce true;
    services.desktopManager.cosmic.enable = true;

    environment.systemPackages = [
      pkgs.cosmic-ext-ctl # CLI
      pkgs.cosmic-ext-tweaks
      # pkgs.cosmic-ext-applet-caffeine
      # pkgs.cosmic-ext-applet-clipboard-manager
      # pkgs.cosmic-ext-applet-emoji-selector
      # pkgs.cosmic-reader
      # pkgs.observatory
    ];

    environment.sessionVariables = {
      COSMIC_DATA_CONTROL_ENABLED = "1";
    };

    # systemd = {
    #   packages = [pkgs.observatory];
    #   services.monitord.wantedBy = ["multi-user.target"];
    # };
  };
}
