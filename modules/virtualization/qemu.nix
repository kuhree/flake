{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kQEMU;
in {
  options.kQEMU = {enable = lib.mkEnableOption "enable virtualization";};

  config = lib.mkIf cfg.enable {
    environment = {systemPackages = [pkgs.qemu pkgs.dive pkgs.lazydocker];};

    virtualisation = {
      libvirtd = {
        enable = true;
        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          swtpm = {enable = true;};
          ovmf = {
            enable = true;
            packages = [
              (pkgs.OVMF.override {
                secureBoot = false;
                tpmSupport = false;
              })
              .fd
            ];
          };
        };
      };
    };

    programs = {virt-manager = {enable = true;};};

    users.groups = {libvirtd.members = config.users.groups.wheel.members;};
  };
}
