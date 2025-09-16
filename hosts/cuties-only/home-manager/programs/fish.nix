{
  programs.fish = {
    enable = true;
    shellInit = "set fish_greeting";
    loginShellInit = ''
      if uwsm check may-start
        exec uwsm start hyprland-uwsm.desktop
      end
    '';
    shellAbbrs = {
      s = "sudo";
      k = "kill";
      pk = "pkill";
      vv = "sudoedit";
      m = "man";
      t = "time";
      mc = "man configuration.nix";
      nf = "nix fmt .";
      nfu = "nix flake update";

      ":q" = "exit";
      ":wq" = "exit";
    };
    shellAliases = {
      cp = "cp -i";
      ln = "ln -i";
      mv = "mv -i";
      rm = "rm -i";
      mkdir = "mkdir -pv";
      mount = "mount | column -t";
    };
  };
}
