{
  inputs,
  pkgs,
  ...
}: {
  dev = [
    pkgs.aider-chat
    pkgs.ansible
    pkgs.clang
    pkgs.gnumake
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
    pkgs.alejandra # inputs.alejandra.defaultPackage.${pkgs.system}
  ];

  shell = [
    pkgs.bitwarden-cli
    pkgs.curl
    pkgs.ffmpeg
    pkgs.gcc
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
    pkgs.nerd-fonts.zed-mono

    # Icons
    pkgs.font-awesome
    pkgs.material-design-icons
    pkgs.material-icons
    pkgs.noto-fonts
    pkgs.noto-fonts-cjk-sans
    pkgs.noto-fonts-emoji
  ];

  gui = [
    inputs.zen-browser.packages."${pkgs.system}".beta
    pkgs.bitwarden-desktop
    pkgs.brave
    pkgs.ghostty # inputs.ghostty.packages."${pkgs.system}".default
    pkgs.obs-studio
    pkgs.obsidian
    pkgs.syncthing
    pkgs.syncthingtray
    pkgs.vesktop
  ];

  utils = [
    pkgs.brightnessctl
    pkgs.cava
    pkgs.gparted
    pkgs.libnotify
    pkgs.libva-utils
    pkgs.mpv
    # pkgs.networkmanagerapplet
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

  gnome = [
    pkgs.gnome.gnome-tweaks
  ];

  hyprland = [
    pkgs.hyprcursor
    pkgs.hypridle
    pkgs.hyprland-protocols
    pkgs.hyprpicker
    pkgs.rofi-wayland
    pkgs.mako
    pkgs.swww
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

  x11 = [];

  wayland = [
    pkgs.udiskie
  ];
}
