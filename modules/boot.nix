{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kBoot;
in {
  options.kBoot = {enable = lib.mkEnableOption "enable common boot options";};

  config = lib.mkIf cfg.enable {
    boot = {
      tmp = {
        cleanOnBoot = true;
        useTmpfs = true;
      };

      initrd = {
        verbose = false;
        systemd.enable = true;
      };

      kernelPackages = pkgs.linuxPackages_zen;
      kernelParams = [
        # fix for suspend issues
        # see: https://www.reddit.com/r/archlinux/comments/e5oe4p/comment/fa8mzft/
        "snd_hda_intel.dmic_detect=0"
        "acpi_osi=linux"
        "nowatchdog"

        # Perf
        "mitigations=off"
        "preempt=full"
        "init_on_alloc=0"
        "init_on_free=0"
      ];

      kernel.sysctl = {
        "vm.swappiness" = 10;
        "kernel.nmi_watchdog" = 0;
        "vm.dirty_ratio" = 60;
        "vm.dirty_background_ratio" = 2;
      };

      bootspec.enable = true;
      loader = {
        systemd-boot = {
          enable = lib.mkDefault true;
          memtest86.enable = true;
          configurationLimit = 10;
          editor = false;
        };

        # spam space to get to boot menu
        timeout = 0;
        efi.canTouchEfiVariables = true;
      };
    };
  };
}
