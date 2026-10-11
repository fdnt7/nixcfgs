{
  # Loads a project's environment on `cd`; nix-direnv caches `use flake` so
  # it is instant after the first time and survives garbage collection.
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    config.global.warn_timeout = "0s";
  };
}
