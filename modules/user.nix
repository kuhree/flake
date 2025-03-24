{
  lib,
  config,
  pkgs,
  kVars,
  ...
}: let
  cfg = config.kUser;
in {
  options.kUser = {enable = lib.mkEnableOption "enable common user account";};

  config = lib.mkIf cfg.enable {
    users = {
      defaultUserShell = pkgs.zsh;
      mutableUsers = true;
      users = {
        root = {initialPassword = "nixos";};

        "${kVars.username}" = {
          uid = 1000;
          isNormalUser = true;
          initialPassword = "nixos";
          description = "good vibes...";
          extraGroups = [
            "abdusers"
            "audio"
            "docker"
            "input"
            "kvm"
            "libvirtd"
            "lp"
            "networkmanager"
            "nix"
            "plugdev"
            "power"
            "systemd-journal"
            "vboxusers"
            "video"
            "wheel"
            "wireshark"
          ];
        };
      };
    };

    security = {
      sudo = {
        enable = true;
        extraRules = [
          {
            commands =
              builtins.map (command: {
                command = "/run/current-system/sw/bin/${command}";
                options = ["NOPASSWD"];
              }) [
                "poweroff"
                "reboot"
                "nixos-rebuild"
                "nix-env"
                "bandwhich"
                "systemctl"
              ];
            groups = ["wheel"];
          }
        ];
      };

      pam = {
        services = {
          login = {
            enableGnomeKeyring = true;
            fprintAuth = true;
          };
          sudo.fprintAuth = true;
          swaylock.fprintAuth = true;
        };

        loginLimits = [
          {
            domain = "@wheel";
            item = "nofile";
            type = "soft";
            value = "524288";
          }
          {
            domain = "@wheel";
            item = "nofile";
            type = "hard";
            value = "1048576";
          }
        ];
      };
    };
  };
}
