{
  config,
  nixcfgs,
  ...
}:
let
  file = "seguiemj.ttf";
in
{
  xdg.dataFile."fonts/${file}".source =
    config.lib.file.mkOutOfStoreSymlink "${nixcfgs.persist}/usr/share/fonts/${file}";

  fonts.fontconfig.defaultFonts.emoji = [ "Segoe UI Emoji" ];
}
