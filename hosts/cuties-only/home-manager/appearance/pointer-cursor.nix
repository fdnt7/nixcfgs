{pkgs, ...}: {
  home.pointerCursor = let
    dir = "Posy_Cursor_Black";
  in {
    gtk.enable = true;
    package = pkgs.posy-cursors.overrideAttrs (old: {
      # changed `Posy_Cursor` to `Posy_Cursor_Black` for black cursors
      installPhase = ''
        runHook preInstall
        mkdir -p $out/share/icons
        cp -r ${dir} $out/share/icons
        runHook postInstall
      '';
    });
    name = dir;
    size = 20;
  };
}
