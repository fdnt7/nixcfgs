{ lib, pkgs, ... }:
{
  fonts.fontconfig = {
    enable = true;
    # Programs ask for "monospace" and get this, so the family is named once.
    #
    # Thai after each: DejaVu and JetBrains Mono have none, and fontconfig
    # otherwise falls back to FreeSerif, a looped serif that is hard to read
    # small. Noto Sans Thai is the loopless design, and covers Thai alone, so
    # it changes nothing of Latin text; DejaVu is named first to keep the
    # spaces between Latin words. Serif Thai is looped by tradition; Noto's
    # at least keeps its strokes even. After, so that a user who sets these
    # lists in a module of their own keeps theirs first.
    defaultFonts = {
      monospace = lib.mkMerge [
        [ "JetBrainsMono Nerd Font" ]
        (lib.mkAfter [ "Noto Sans Thai" ])
      ];
      sansSerif = lib.mkAfter [
        "DejaVu Sans"
        "Noto Sans Thai"
      ];
      serif = lib.mkAfter [
        "DejaVu Serif"
        "Noto Serif Thai"
      ];
    };
  };

  home.packages = [
    pkgs.nerd-fonts.jetbrains-mono
    pkgs.noto-fonts
  ];
}
