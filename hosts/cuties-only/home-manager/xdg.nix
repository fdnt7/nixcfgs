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
      CARGO_HOME = "${xdgDataHome}/cargo";
      HISTFILE = "${xdgStateHome}/bash/history";
      PYTHON_HISTORY = "${xdgDataHome}/python/history";
    };
  };

  nix.settings.use-xdg-base-directories = true;

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = null;
      publicShare = null;
      templates = null;
      extraConfig = {
        XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
      };
    };
  };
}
