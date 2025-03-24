{
  pkgs,
  inputs,
  system,
  ...
}: {
  dev = [
    pkgs.aider-chat
    pkgs.ansible
    pkgs.clang
    pkgs.gnumake
    pkgs.opentofu
    pkgs.packer
    pkgs.lazydocker
    pkgs.lazygit

    # LSP
    pkgs.go
    pkgs.gcc
    pkgs.nodejs
    pkgs.bun
    pkgs.nixd
    pkgs.nil
    pkgs.nixfmt-classic
    pkgs.python3
    pkgs.cargo
    pkgs.rustc
    inputs.alejandra.defaultPackage.${system}
  ];

  shell = [
    pkgs.bitwarden-cli
    pkgs.curl
    pkgs.ffmpeg
    pkgs.fzf
    pkgs.git
    pkgs.glow
    pkgs.htop
    pkgs.imagemagick
    pkgs.iptables
    pkgs.jq
    pkgs.lf
    pkgs.neovim
    pkgs.nftables
    pkgs.openssl
    pkgs.pistol
    pkgs.ripgrep
    pkgs.rsync
    pkgs.sshpass
    pkgs.tmux
    pkgs.tmuxPlugins.rose-pine
    pkgs.tmuxPlugins.sensible
    pkgs.tmuxPlugins.tmux-fzf
    pkgs.unzip
    pkgs.vim
    pkgs.wget
    pkgs.zsh
  ];

  gui = [
    pkgs.bitwarden-desktop
    pkgs.calibre
    pkgs.obs-studio
    pkgs.syncthing
    pkgs.syncthingtray
    pkgs.shotcut
    pkgs.thunderbird
    pkgs.brave

    # Unfree
    pkgs.obsidian
    pkgs.vesktop

    # Unstable
    inputs.zen-browser.packages."${system}".beta
    inputs.ghostty.packages."${system}".default
  ];

  fonts = [
    # UI
    pkgs.inter
    pkgs.lato
    pkgs.lexend
    pkgs.liberation_ttf
    pkgs.roboto
    pkgs.roboto-mono
    pkgs.ubuntu_font_family

    # Nerd Fonts
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.nerd-fonts.geist-mono

    # Icons
    pkgs.font-awesome
    pkgs.material-design-icons
    pkgs.material-icons
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-emoji
  ];

  utils = [
    pkgs.brightnessctl
    pkgs.cava
    pkgs.gparted
    pkgs.libnotify
    pkgs.libva-utils
    pkgs.mpv
    pkgs.networkmanagerapplet
    pkgs.pamixer
    pkgs.pavucontrol
    pkgs.playerctl
    pkgs.polkit_gnome
    pkgs.udiskie
    pkgs.via
    pkgs.xdg-user-dirs
    pkgs.xdg-utils
  ];

  gtk = [
    pkgs.arc-icon-theme
    pkgs.arc-theme
    pkgs.breeze-hacked-cursor-theme
    pkgs.gsettings-desktop-schemas
    pkgs.themechanger
    pkgs.whitesur-cursors
    pkgs.whitesur-gtk-theme
    pkgs.whitesur-icon-theme
  ];

  qt = [
    # qt5
    pkgs.qadwaitadecorations
    pkgs.libsForQt5.breeze-grub
    pkgs.libsForQt5.breeze-gtk
    pkgs.libsForQt5.breeze-icons
    pkgs.libsForQt5.breeze-qt5
    pkgs.libsForQt5.qt5ct
    pkgs.libsForQt5.qtstyleplugin-kvantum # kvantum
    pkgs.qt5.qtwayland

    # qt6
    # pkgs.qadwaitadecorations-qt6
    # pkgs.qt6.qmake
    # pkgs.qt6.qtwayland
    # pkgs.qt6Packages.qtstyleplugin-kvantum # kvantum
    # pkgs.qt6ct
  ];

  gnome = [];

  wayland = [
    pkgs.udiskie
    pkgs.rofi-wayland
    pkgs.wlogout
    pkgs.wlr-randr
    pkgs.wlsunset
    # clipboard
    pkgs.cliphist
    pkgs.wl-clipboard
    # scrot
    pkgs.grim
    pkgs.grimblast
    pkgs.slurp
    pkgs.swappy
  ];

  hyprland = [
    pkgs.hyprcursor
    pkgs.hypridle
    pkgs.hyprpicker
    pkgs.hyprland-protocols
    pkgs.swaynotificationcenter

    inputs.swww.packages.${pkgs.system}.swww
  ];
}
