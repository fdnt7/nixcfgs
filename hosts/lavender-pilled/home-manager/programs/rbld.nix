{ inputs, nixcfgs, ... }: {
  imports = [ inputs.rbld.homeModules.default ];

  programs.rbld = {
    enable = true;
    settings.flake = nixcfgs.flake;
  };
}
