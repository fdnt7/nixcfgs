{
  config,
  pkgs,
  ...
}: let
  configXdg = config.xdg;
  xdgDataHome = configXdg.dataHome;
in {
  home = {
    packages = [pkgs.xdg-ninja];
    sessionVariables = let
      xdgStateHome = configXdg.stateHome;
      xdgConfigHome = configXdg.configHome;
    in {
      CARGO_HOME = "${xdgDataHome}/cargo";
      HISTFILE = "${xdgStateHome}/bash/history";
      PYTHON_HISTORY = "${xdgDataHome}/python/history";
      WAKATIME_HOME = "${xdgConfigHome}/wakatime";
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

  programs.fish.shellAliases.wget = "wget --hsts-file=${xdgDataHome}/wget-hsts";
}
