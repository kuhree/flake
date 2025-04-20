{
  lib,
  config,
  pkgs,
  kPkgs,
  ...
}: let
  cfg = config.kShell;
in {
  options.kShell = {enable = lib.mkEnableOption "shell environment";};

  config = lib.mkIf cfg.enable {
    programs = {
      git = {
        enable = true;
        lfs = {enable = true;};
      };
      starship = {enable = true;};
      tmux = {enable = true;};
      zsh = {
        enable = true;
        enableCompletion = true;
        enableBashCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
      };

      nix-ld = {
        enable = true;
        libraries = [
          # Add any missing dynamic libraries for unpackaged programs
          # here, NOT in environment.systemPackages
          pkgs.starship
        ];
      };
    };

    environment = {
      systemPackages = kPkgs.shell;
    };
  };
}
