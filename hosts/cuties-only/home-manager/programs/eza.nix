{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    colors = "auto";
    git = true;
    icons = "auto";

    extraOptions = ["-lah" "--group-directories-first" "--colour-scale"];
  };

  # no `catppuccin.eza` yet

  # `programs.eza.theme` exists, but it accepts a nix set as a yaml, so if a
  # yaml file already exists, there appears to be no trivial way to convert
  # it to a nix set. so, a direct symlink is used instead
  xdg.configFile."eza/theme.yml".source = let
    repo = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "eza";
      rev = "70f805f6cc27fa5b91750b75afb4296a0ec7fec9";
      hash = "sha256-Q+C07IReQQBO5xYuFiFbS1wjmO4gdt/wIJWHNwIizSc=";
    };
    catppuccinCfg = config.catppuccin;
    catppuccinFlavour = catppuccinCfg.flavor;
  in "${repo}/themes/${catppuccinFlavour}/catppuccin-${catppuccinFlavour}-${catppuccinCfg.accent}.yml";
}
