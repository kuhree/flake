{lib, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/boot.nix
    ../../modules/fonts.nix
    ../../modules/locale.nix
    ../../modules/networking.nix
    ../../modules/nix.nix
    ../../modules/security.nix
    ../../modules/shell.nix
    ../../modules/user.nix

    ../../modules/virtualization/qemu_guest.nix
    ../../modules/virtualization/docker.nix
  ];

  kNix = {enable = true;};
  kBoot = {enable = false;};
  kFonts = {enable = true;};
  kNet = {enable = true;};
  kSecurity = {enable = true;};
  kShell = {enable = true;};
  kGuest = {enable = true;};
  kDocker = {enable = true;};
  kUser = {
    enable = true;
    username = "kuhree";
  };
  kLocale = {
    enable = true;
    locale = "en_US.UTF-8";
    hostname = "thinkpad";
  };

  virtualisation.vmVariant = {
    # following configuration is added only when building VM with build-vm
    virtualisation = {
      memorySize = 2048; # Use 2048MiB memory.
      cores = 3;
    };
  };

  # Overrides
  boot = {
    loader = {
      systemd-boot.enable = false;
      grub = {
        enable = lib.mkForce true;
        device = "/dev/vda";
        useOSProber = true;
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
