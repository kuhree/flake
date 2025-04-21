{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.kNix;
in {
  options.kNix = {enable = lib.mkEnableOption "enable nixos config";};

  config = lib.mkIf cfg.enable {
    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };

    nix = {
      package = pkgs.lix;
      nixPath = ["nixpkgs=${inputs.nixpkgs}"];

      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 10d";
      };

      # Optimize build performance
      daemonCPUSchedPolicy = "batch";
      daemonIOSchedClass = "best-effort";
    };

    systemd = {
      # WE DONT WANT TO BUILD STUFF ON TMPFS
      # ITS NOT A GOOD IDEA
      services.nix-daemon = {environment.TMPDIR = "/var/tmp";};
    };

    system = {
      autoUpgrade = {
        enable = true;
        dates = "weekly";
      };

      # this makes rebuilds little faster
      switch = {
        enable = false;
        enableNg = true;
      };
    };
  };
}
