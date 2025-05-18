{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kSteam;
in {
  options.kSteam = {
    enable = lib.mkEnableOption "enable steam";

    username = lib.mkOption {
      default = "kuhree";
      example = "kuhree";
      description = "the username for the primary user";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    # Toggle Steam w/ Extras
    programs.gamemode = {enable = true;};
    programs.steam = {
      enable = true;
      gamescopeSession = {enable = true;};
    };
    environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${cfg.username}/.steam/root/compatibilitytools.d"; # force steam to use protonup/protonge

    users.users."${cfg.username}".packages = [pkgs.protonup pkgs.mangohud pkgs.lutris pkgs.bottles pkgs.heroic];
  };
}
