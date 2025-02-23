{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kNvidiaDrivers;
in {
  options.kNvidiaDrivers = {
    enable =
      lib.mkEnableOption
      "enable nvidia drivers (and possible container-toolkit)";

    gpuId = lib.mkOption {
      default = "PCI:1:0:0";
      description = ''
        ID for GPU
        run `nix shell nixpkgs#pciutils -c lspci | grep ' VGA '` to get ids
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot = {kernelParams = ["nvidia-drm.modeset=1" "nvidia-drm.fbdev=1"];};

    services = {
      xserver = {
        videoDrivers = ["nvidia"]; # Enable nvidia drivers X/Wayland
      };
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = [
          pkgs.libva
          pkgs.libva-utils
          pkgs.vulkan-tools
          pkgs.vulkan-validation-layers
        ];
      };

      nvidia-container-toolkit = {enable = true;};
      nvidia = {
        open = true;
        modesetting = {enable = true;};
        nvidiaSettings = true;
        powerManagement.enable = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;

        # prime = {
        #   # USE ONE sync (performance) OR offload (battery)
        #   sync = { enable = true; };
        #   # offload = { enable = true; enableOffloadCmd = true; };
        #
        #   nvidiaBusId = cfg.gpuId; # dedicated GPU
        #   # intelBusId = "PCI:0:0:0"; # integrated Intel GPU
        #   # amdgpuBusId = "PCI:6:0:0"; # integrated AMD GPU
        # };
      };
    };

    environment = {
      sessionVariables = {
        GBM_BACKEND = "nvidia-drm";
        LIBVA_DRIVER_NAME = "nvidia";
        WLR_RENDERER = "vulkan";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        __GL_GSYNC_ALLOWED = "0";
        __GL_VRR_ALLOWED = "0";
      };
    };
  };
}
