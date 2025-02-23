{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kSecurity;
in {
  options.kSecurity = {
    enable = lib.mkEnableOption "enable common security options";
  };

  config = lib.mkIf cfg.enable {
    services = {
      networkd-dispatcher.enable = true;
      openssh = {
        enable = true;
        settings = {PermitRootLogin = "no";};
      };
    };

    programs = {
      gnupg = {
        agent = {
          enable = true;
          enableBrowserSocket = true;
          enableSSHSupport = false; # prefer ssh-agent
        };
      };

      ssh = {
        startAgent = true;
        enableAskPassword = true;
      };
    };

    security = {
      polkit.enable = true;
      rtkit.enable = true;
      protectKernelImage = true;
      lockKernelModules = true;
      forcePageTableIsolation = true;
      auditd = {enable = true;};
      audit = {enable = true;};
      apparmor = {
        enable = true;
        killUnconfinedConfinables = true;
        packages = [pkgs.apparmor-profiles];
      };
    };

    boot = {
      blacklistedKernelModules = [
        # Obscure network protocols
        "ax25"
        "netrom"
        "rose"
        # Old or rare or insufficiently audited filesystems
        "adfs"
        "affs"
        "bfs"
        "befs"
        "cramfs"
        "efs"
        "erofs"
        "exofs"
        "freevxfs"
        "f2fs"
        "vivid"
        "gfs2"
        "ksmbd"
        "nfsv4"
        "nfsv3"
        "cifs"
        "nfs"
        "cramfs"
        "freevxfs"
        "jffs2"
        "hfs"
        "hfsplus"
        "squashfs"
        "udf"
        "hpfs"
        "jfs"
        "minix"
        "nilfs2"
        "omfs"
        "qnx4"
        "qnx6"
        "sysv"
      ];
    };
  };
}
