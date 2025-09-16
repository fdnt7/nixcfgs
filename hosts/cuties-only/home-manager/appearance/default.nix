{
  imports = [
    ./catppuccin.nix
    #./gtk.nix
    ./pointer-cursor.nix
  ];

  # set system theme to dark
  dconf.settings = {
    "org/freedesktop/appearance".color-scheme = 1;
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
