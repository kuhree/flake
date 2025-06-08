{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.kNet;
in {
  options.kNet = {
    enable = lib.mkEnableOption "enable common networking (w/ tailscale)";
    hostname = lib.mkOption {
      default = "nixos";
      example = "nixos";
      description = "the hostname of the device";
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      resolved = {enable = true;};
      tailscale = {
        enable = true;
        package = pkgs.tailscale;
      };
    };

    networking = {
      hostName = cfg.hostname;
      nftables = {enable = true;};

      # Commented out -- Enables systemd-networkd
      interfaces = {
        wlp5s0 = {useDHCP = true;};
      };

      wireless.enable = true;
      networkmanager = {
        enable = true;
        unmanaged = ["docker0" "rndis0" "tailscale0"];
        wifi = {
          macAddress = "random";
          powersave = true;
        };
      };

      firewall = {
        enable = true;
        allowPing = false;
        logReversePathDrops = true;
        trustedInterfaces = ["tailscale0"];
        allowedUDPPorts = [config.services.tailscale.port];
        allowedTCPPorts = [22 8080];
        allowedTCPPortRanges = [
          {
            from = 8000;
            to = 9000;
          } # Packer/Dev
        ];
      };
    };

    # slows down boot time
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
