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

      settings = {
        extra-substituters = [
          "https://cache.nixos.org"
          "https://cache.garnix.io/"
          "https://nix-community.cachix.org/"
          "https://hyprland.cachix.org/"
        ];
        extra-trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];

        accept-flake-config = true;
        auto-optimise-store = true;
        builders-use-substitutes = true; # use binary cache, its not gentoo
        commit-lockfile-summary = "chore: Update flake.lock";
        experimental-features = [ "flakes" "nix-command" ];
        flake-registry = "/etc/nix/registry.json";
        http-connections = 50;
        show-trace = true;
        trusted-users = ["@wheel" "@builders"];
        warn-dirty = false;
      };
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
