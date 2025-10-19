{
  inputs,
  pkgs,
  ...
}:
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  programs.spicetify =
    let
      spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
    in
    {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [ adblock ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };

  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [ "workspace special:music, class:^(Spotify)$" ];
    bind = [ "$mod ALT, s, exec, uwsm-app -- spotify" ];
  };
}
