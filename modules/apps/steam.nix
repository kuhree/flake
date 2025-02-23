{
  lib,
  config,
  pkgs,
  kVars,
  ...
}: let
  cfg = config.kSteam;
in {
  options.kSteam = {enable = lib.mkEnableOption "enable steam";};

  config = lib.mkIf cfg.enable {
    # Toggle Steam w/ Extras
    programs.gamemode = {enable = true;};
    programs.steam = {
      enable = true;
      gamescopeSession = {enable = true;};
    };
    environment.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/${kVars.username}/.steam/root/compatibilitytools.d"; # force steam to use protonup/protonge

    users.users."${kVars.username}".packages = [pkgs.protonup pkgs.mangohud pkgs.lutris pkgs.bottles pkgs.heroic];
  };
}
