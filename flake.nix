{
  description = "Kuhree's NixOS Config(s)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
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
  in {
    # Shell(s)
    devShells = {
      "${pkgs.system}" = {
        default = pkgs.mkShell {
          packages = kPkgs.shell ++ kPkgs.dev;
          shellHook = ''
            exec zsh
          '';
        };
      };
    };

    # Host(s)
    nixosConfigurations = {
      thinkpad = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs kPkgs;};
        modules = [./hosts/thinkpad/configuration.nix];
      };

      vm = inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs kPkgs;};
        modules = [./hosts/vm/configuration.nix];
      };
    };
  };
}
