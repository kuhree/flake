{
  lib,
  config,
  ...
}: let
  cfg = config.kGuest;
in {
  options.kGuest = {
    enable = lib.mkEnableOption "qemu quest agent";
  };

  config = lib.mkIf cfg.enable {
    services = {
      qemuGuest.enable = true;
      spice-vdagentd.enable =
        true; # enable copy and paste between host and guest
    };
  };
}
