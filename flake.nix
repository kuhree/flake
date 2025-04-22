{
  description = "Kuhree's NixOS Config(s)";
  nixConfig = {
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
    experimental-features = [
      # "ca-derivations"
      # "recursive-nix"
      "flakes"
      "nix-command"
    ];

    accept-flake-config = true;
    auto-optimise-store = true;
    builders-use-substitutes = true; # use binary cache, its not gentoo
    commit-lock-file-summary = "chore: Update flake.lock";
    flake-registry = "/etc/nix/registry.json";
    http-connections = 50;
    show-trace = true;
    trusted-users = ["@wheel" "@builders"];
    warn-dirty = false;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";

    # Unused flakes
    # ghostty.url = "github:ghostty-org/ghostty";
    # hyprland = {
    #   url = "github:hyprwm/Hyprland";
    #   # inputs.nixpkgs.follows = "nixpkgs"; # If mesa/opengl gets a mismatch
    # };
  };

  outputs = {...} @ inputs: let
    system = "x86_64-linux";
    pkgs = import inputs.nixpkgs {
      inherit system;
      # Required for flakes: must enable unfree packages before importing them
      # This allows installation of proprietary software like Nvidia Drivers or Obsidian
      config.allowUnfree = true;
    };

    kPkgs = import ./packages.nix {inherit inputs pkgs;};
    kVars = import ./variables.nix {inherit inputs;};
  in {
    # Shell(s)
    devShells = {
      "${pkgs.system}" = {
        default = pkgs.mkShell {
          packages = kPkgs.shell ++ kPkgs.dev;
          shellHoock = ''
            exec zsh
          '';
        };
      };
    };

    # Host(s)
    nixosConfigurations = {
      thinkpad = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs kPkgs kVars;};
        modules = [./hosts/thinkpad/configuration.nix];
      };

      vm = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs kPkgs kVars;};
        modules = [./hosts/vm/configuration.nix];
      };
    };
  };
}
