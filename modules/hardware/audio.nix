{
  lib,
  config,
  ...
}: let
  cfg = config.kAudio;
in {
  options.kAudio = {enable = lib.mkEnableOption "enable pipewire audio";};

  config = lib.mkIf cfg.enable {
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;

      pulse = {enable = true;};
      jack = {enable = true;};
      alsa = {
        enable = true;
        support32Bit = true;
      };

      wireplumber = {
        enable = true;
        extraConfig = {
          # workaround for high battery usage
          "10-disable-camera" = {
            "wireplumber.profiles" = {
              main = {"monitor.libcamera" = "disabled";};
            };
          };
        };
      };

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}
