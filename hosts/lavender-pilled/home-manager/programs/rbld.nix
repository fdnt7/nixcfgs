{ inputs, nixcfgs, ... }: {
  imports = [ inputs.rbld.homeModules.default ];

  programs = {
    fish.shellAbbrs = {
      s = "rbld switch";
      u = "rbld update";
    };
    rbld = {
      enable = true;
      settings.flake = nixcfgs.flake;
    };
  };
}
