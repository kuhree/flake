{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kDocker;
in {
  options.kDocker = {enable = lib.mkEnableOption "enable docker";};

  config = lib.mkIf cfg.enable {
    environment = {systemPackages = [pkgs.lazydocker];};

    boot.kernelModules = ["nf_tables" "x_tables" "iptable_filter" "iptable_nat"];

    virtualisation = {
      docker = {
        extraOptions = "--iptables=false";
        enable = true;

        autoPrune = {
          enable = true;
          flags = ["--all"];
        };

        daemon = {
          settings = {
            ip = "127.0.0.1";
            data-root = "/opt/docker";
          };
        };
      };

      oci-containers = {backend = "docker";};
    };

    users.groups = {docker.members = config.users.groups.wheel.members;};
  };
}
