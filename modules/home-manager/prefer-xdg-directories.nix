{
  config,
  lib,
  ...
}:
let
  inherit (config.xdg)
    dataHome
    stateHome
    configHome
    cacheHome
    ;

  android = {
    home.sessionVariables.ANDROID_USER_HOME = "${dataHome}/android";
  };

  bash = {
    home.sessionVariables.HISTFILE = "${stateHome}/bash/history";
  };

  cargo = {
    home.sessionVariables.CARGO_HOME = "${dataHome}/cargo";
  };

  claude-code = {
    home.sessionVariables.CLAUDE_CONFIG_DIR = "${configHome}/claude";
  };

  codex = {
    home.sessionVariables.CODEX_HOME = "${configHome}/codex";
  };

  elan = {
    home.sessionVariables.ELAN_HOME = "${dataHome}/elan";
  };

  gtk2 = {
    home.sessionVariables.GTK2_RC_FILES = "${configHome}/gtk-2.0/gtkrc";
  };

  nix = {
    nix.settings.use-xdg-base-directories = true;
  };

  node = {
    home.sessionVariables.NODE_REPL_HISTORY = "${stateHome}/node_repl_history";
  };

  npm = {
    home.sessionVariables = {
      NPM_CONFIG_INIT_MODULE = "${configHome}/npm/config/npm-init.js";
      NPM_CONFIG_CACHE = "${cacheHome}/npm";
      NPM_CONFIG_TMP = "${stateHome}/npm";
    };
  };

  openjdk = {
    home.sessionVariables._JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${configHome}/java";
  };

  python = {
    home.sessionVariables = {
      PYTHON_HISTORY = "${stateHome}/python_history";
      PYTHONPYCACHEPREFIX = "${cacheHome}/python";
      PYTHONUSERBASE = "${dataHome}/python";
    };
  };

  wakatime = {
    home.sessionVariables.WAKATIME_HOME = "${configHome}/wakatime";
  };

  wget = {
    programs.fish.shellInit = ''
      if type -q wget
          alias wget="wget --hsts-file=${dataHome}/wget-hsts"
      end
    '';
  };
in
{
  config = lib.mkIf config.home.preferXdgDirectories (
    lib.mkMerge [
      android
      bash
      cargo
      claude-code
      codex
      elan
      gtk2
      nix
      node
      npm
      openjdk
      python
      wakatime
      wget
    ]
  );
}
