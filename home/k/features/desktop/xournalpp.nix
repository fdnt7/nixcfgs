{ pkgs, ... }:
{
  # Handwritten notes and PDF annotation with the stylus. There is no
  # module.
  home.packages = [ pkgs.xournalpp ];
}
