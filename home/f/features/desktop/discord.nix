{ pkgs, ... }:
{
  # Not programs.discord: it links a generated settings.json, while
  # Discord keeps state there (window bounds). The package's launcher
  # script already adds the update-skipping keys to a plain file itself,
  # and renames a new file over a link, which Home Manager refuses to
  # clobber. Seen 2026-11-05, when nixpkgs began requiring
  # SKIP_MODULE_UPDATE too, which the module's file lacks.
  home.packages = [ pkgs.discord ];
}
