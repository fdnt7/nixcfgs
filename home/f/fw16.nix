{ config, ... }:
{
  imports = [
    ./global
    ./features/cli
    ./features/desktop
    ./features/games
  ];

  # The NVIDIA driver keeps its compute cache in ~/.nv unless told otherwise.
  home.sessionVariables.CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";

  wayland.windowManager.niri.extraConfig = ''
    // The built-in 2560x1600 panel.
    output "eDP-1" {
        scale 1.25
    }

    // Render on the AMD iGPU, which drives the panel. Left to itself niri
    // sometimes picks the NVIDIA GPU, which then has to wake from runtime
    // suspend before anything can be drawn. The path is by PCI address
    // because the renderD numbers swap between boots.
    debug {
        render-drm-device "/dev/dri/by-path/pci-0000:c3:00.0-render"
    }
  '';
}
