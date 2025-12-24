{
  config,
  lib,
  ...
}:
{
  config =
    let
      inherit (config.xdg)
        dataHome
        stateHome
        configHome
        cacheHome
        ;
    in
    lib.mkIf config.home.preferXdgDirectories {
      nix.settings.use-xdg-base-directories = true;

      home.sessionVariables.GTK2_RC_FILES = "${configHome}/gtk-2.0/gtkrc";

      home.sessionVariables.ANDROID_USER_HOME = "${dataHome}/android";

      home.sessionVariables.HISTFILE = "${stateHome}/bash/history";

      home.sessionVariables.CARGO_HOME = "${dataHome}/cargo";

      home.sessionVariables.CODEX_HOME = "${configHome}/codex";

      home.sessionVariables.NODE_REPL_HISTORY = "${stateHome}/node_repl_history";

      home.sessionVariables.PYTHON_HISTORY = "${stateHome}/python_history";
      home.sessionVariables.PYTHONPYCACHEPREFIX = "${cacheHome}/python";
      home.sessionVariables.PYTHONUSERBASE = "${dataHome}/python";

      programs.fish = {
        shellInit = ''
          if type -q wget
              alias wget="wget --hsts-file=${dataHome}/wget-hsts"
          end
        '';
      };

      home.sessionVariables.WAKATIME_HOME = "${configHome}/wakatime";
    };
}
