{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = [pkgs.xdg-ninja];
    sessionVariables = let
      xdgDataHome = config.xdg.dataHome;
      xdgStateHome = config.xdg.stateHome;
    in {
      PYTHON_HISTORY = "${xdgDataHome}/python/history";
      HISTFILE = "${xdgStateHome}/bash/history";
    };
  };

  nix.settings.use-xdg-base-directories = true;

  xdg.enable = true;
}
