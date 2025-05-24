{...}: {
  imports = [
    ../../profiles/workstation.nix
    ./hardware-configuration.nix
  ];

  kWorkstation = {
    enable = true;
    username = "kuhree";
    timezone = "America/New_York";
    locale = "en_US.UTF-8";
    hostname = "thinkpad";
    # login = "greetd";
    # desktop = "hyprland";
    login = "cosmic";
    desktop = "cosmic";
    extras = {
      enable = true;
    };

    hardware = {
      laptop = true;
      intel = true;
      keyboard = true;
    };

    virtualization = {
      qemu = true;
      docker = true;
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
