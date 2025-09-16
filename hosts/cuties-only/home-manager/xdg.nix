{
  config,
  pkgs,
  ...
}: {
  home = {
    packages = [pkgs.xdg-ninja];
    sessionVariables = let
      xdgDataHome = config.xdg.dataHome;
    in {
      PYTHON_HISTORY = "${xdgDataHome}/python/history";
    };
  };

  nix.settings.use-xdg-base-directories = true;

  xdg.enable = true;
}
