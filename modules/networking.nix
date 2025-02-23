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
  };

  config = lib.mkIf cfg.enable {
    services = {
      resolved = {enable = true;};
      tailscale = {
        enable = true;
        package = pkgs.tailscale;
      };

      # encrypted dns
      dnscrypt-proxy2 = {
        enable = true;
        settings = {
          require_dnssec = true;

          sources.public-resolvers = {
            urls = [
              "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
              "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
            ];
            cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
            minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          };
        };
      };
    };

    networking = {
      nftables = {enable = true;};
      interfaces = {
        wlp5s0 = {useDHCP = true;};
        tailscale0 = {useDHCP = false;};
      };

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
        allowedTCPPorts = [22 8080];
        allowedTCPPortRanges = [
          {
            from = 8000;
            to = 9000;
          } # Packer/Dev
        ];
        allowedUDPPorts = [config.services.tailscale.port];
      };
    };

    # slows down boot time
    systemd.services.NetworkManager-wait-online.enable = false;
  };
}
