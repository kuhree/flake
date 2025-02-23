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
    nixpkgs = {config = {allowUnfree = true;};};

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
        # allow sudo users to mark the following values as trusted
        allowed-users = ["@wheel"];
        trusted-users = ["@wheel"];

        accept-flake-config = true;
        auto-optimise-store = true;
        builders-use-substitutes = true; # use binary cache, its not gentoo
        keep-derivations = true;
        keep-outputs = true;
        log-lines = 20;
        max-jobs = "auto";
        cores = 0;
        download-attempts = 2;
        keep-going = true;
        sandbox = true;
        warn-dirty = false;

        flake-registry = "/etc/nix/registry.json";
        commit-lockfile-summary = "chore: Update flake.lock";
        experimental-features = ["nix-command" "flakes" "recursive-nix" "ca-derivations"];
        substituters = ["https://cache.nixos.org" "https://hyprland.cachix.org"];
        trusted-public-keys = [
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
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
