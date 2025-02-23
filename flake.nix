{
  description = "Kuhree's NixOS Config";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    hyprland = {
      url = "github:hyprwm/Hyprland";
      # inputs.nixpkgs.follows = "nixpkgs"; # If mesa/opengl gets a mismatch
    };
    swww = {
      url = "github:LGFae/swww";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xc = {
      url = "github:joerdav/xc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    alejandra = {
      url = "github:kamadorueda/alejandra/3.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };
  };

  outputs = {
    nixpkgs,
    nixos-generators,
    xc,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = system;
      config = {
        # Required for flakes: must enable unfree packages before importing them
        # This allows installation of proprietary software like Nvidia Drivers or Obsidian
        allowUnfree = true;
      };
    };

    kPkgs = import ./packages.nix {inherit inputs system pkgs;};
    kVars = import ./variables.nix {inherit pkgs;};
  in {
    # Shell(s)
    devShells."${system}".default = pkgs.mkShell {
      packages = kPkgs.shell ++ kPkgs.dev;
    };

    # Host(s)
    nixosConfigurations = {
      desktop = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system kPkgs kVars;};
        modules = [./hosts/desktop/configuration.nix];
      };

      thinkpad = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system kPkgs kVars;};
        modules = [./hosts/thinkpad/configuration.nix];
      };

      proxmox = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system kPkgs kVars;};
        modules = [./hosts/proxmox/configuration.nix];
      };

      vm = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs system kPkgs kVars;};
        modules = [./hosts/vm/configuration.nix];
      };
    };
  };
}
