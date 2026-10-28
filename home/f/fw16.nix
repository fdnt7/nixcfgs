{ config, ... }:
{
  imports = [
    ./global
    ./features/cli
    ./features/desktop
    ./features/games
  ];

  # k's machine, over the tailnet, with the key kept on the YubiKey
  # (application ssh:tailnet), each connection asking for a touch. By its
  # tailnet address, as MagicDNS is not taking the system's DNS.
  programs.ssh.settings."fw12" = {
    Hostname = "100.98.146.116";
    User = "k";
    IdentityFile = "~/.ssh/id_ed25519_sk_tailnet";
    IdentitiesOnly = true;

    # Shared as GitHub's is (./features/cli/ssh.nix), so that one touch
    # serves a session.
    ControlMaster = "auto";
    ControlPath = "\${XDG_RUNTIME_DIR}/ssh-%C";
    ControlPersist = "10m";
    ServerAliveInterval = 10;
    ServerAliveCountMax = 2;
  };

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
