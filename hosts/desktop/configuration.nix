{...}: {
  imports = [
    ../../profiles/workstation.nix
    ../../modules/desktop/hyprland.nix
    ./hardware-configuration.nix
  ];

  networking.hostName = "desktop";
  kHyprland = {enable = true;};
  kWorkstation = {
    enable = true;
    greetd = true;
    hardware = {
      nvidia = true;
      keyboard = true;
    };

    virtualization = {
      qemu = true;
      docker = true;
    };

    extras = {enable = true;};
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
