{ lib, ... }:
{
  # Document viewer: small and keyboard-driven, like the image viewer.
  programs.zathura.enable = true;

  # Named one by one rather than taken from the package: its entries also
  # claim folders, archives and pictures, which belong to other programs.
  xdg.mimeApps.defaultApplications =
    lib.genAttrs [
      "application/pdf"
      "application/epub+zip"
      "application/oxps"
    ] (_: "org.pwmt.zathura-pdf-mupdf.desktop")
    // lib.genAttrs [
      "application/postscript"
      "application/eps"
      "application/x-eps"
      "image/eps"
      "image/x-eps"
    ] (_: "org.pwmt.zathura-ps.desktop")
    // lib.genAttrs [
      "image/vnd.djvu"
      "image/vnd.djvu+multipage"
    ] (_: "org.pwmt.zathura-djvu.desktop")
    // lib.genAttrs [
      "application/x-cbr"
      "application/x-cbz"
      "application/x-cb7"
      "application/x-cbt"
    ] (_: "org.pwmt.zathura-cb.desktop");
}
