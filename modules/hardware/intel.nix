{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kIntelDrivers;
in {
  options.kIntelDrivers = {enable = lib.mkEnableOption "intel drivers";};

  config = lib.mkIf cfg.enable {
    boot = {
      kernelParams = ["intel_pstate=active"];
    };

    environment = {
      variables = {
        VDPAU_DRIVER = "va_gl";
      };
    };

    # nixpkgs.config.packageOverrides = pkgs: {
    #   vaapiIntel = pkgs.vaapiIntel.override {
    #     enableHybridCodec = true;
    #   };
    # };

    services.xserver.videoDrivers = ["intel"];
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [
          # pkgs.intel-media-sdk # For older gpus
          pkgs.intel-compute-runtime
          pkgs.intel-media-driver
          pkgs.intel-vaapi-driver
          pkgs.libva
          pkgs.libvdpau-va-gl
          pkgs.ocl-icd
          pkgs.vaapiIntel
          pkgs.vaapiVdpau
          pkgs.vpl-gpu-rt
        ];
      };
    };
  };
}
