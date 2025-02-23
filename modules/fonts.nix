{
  lib,
  config,
  kPkgs,
  ...
}: let
  cfg = config.kFonts;
in {
  options.kFonts = {enable = lib.mkEnableOption "enable common fonts";};

  config = lib.mkIf cfg.enable {
    fonts = {
      enableDefaultPackages = false;
      packages = kPkgs.fonts;

      fontconfig = {
        enable = true;
        defaultFonts = {
          sansSerif = ["Lexend" "Noto Color Emoji"];
          serif = ["Inter" "Noto Color Emoji"];
          monospace = ["GeistMono Nerd Font Mono" "JetBrainsMono Nerd Font" "Noto Color Emoji"];
          emoji = ["Noto Color Emoji"];
        };
      };
    };
  };
}
