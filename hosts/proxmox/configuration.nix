{lib, ...}: {
  imports = [
    ./hardware-configuration.nix

    ../../modules/fonts.nix
    ../../modules/locale.nix
    ../../modules/networking.nix
    ../../modules/nix.nix
    ../../modules/security.nix
    ../../modules/shell.nix
    ../../modules/user.nix

    ../../modules/virtualization/guest.nix
    ../../modules/virtualization/docker.nix
  ];

  kNix = {enable = true;};
  kFonts = {enable = true;};
  kNet = {enable = true;};
  kSecurity = {enable = true;};
  kShell = {enable = true;};
  kLocale = {enable = true;};
  kUser = {enable = true;};
  kGuest = {enable = true;};
  kDocker = {enable = true;};

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
  system.stateVersion = "24.05"; # Did you read the comment?
}
