{
  programs.foot = {
    enable = true;
    settings = {
      # colours are derived from https://github.com/catppuccin/foot
      # but `catppuccin.foot.enable` is not directly used because there have
      # been no translucent option yet
      colors = {
        alpha = 0.67;
        foreground = "cdd6f4";
        background = "1e1e2e";

        regular0 = "585b70";
        regular1 = "f38ba8";
        regular2 = "a6e3a1";
        regular3 = "f9e2af";
        regular4 = "89b4fa";
        regular5 = "f5c2e7";
        regular6 = "94e2d5";
        regular7 = "bac2de";

        bright0 = "82859a";
        bright1 = "ffb5d2";
        bright2 = "d0ffcb";
        bright3 = "ffffd9";
        bright4 = "b3deff";
        bright5 = "ffecff";
        bright6 = "beffff";
        bright7 = "e4ecff";

        dim0 = "2e3146";
        dim1 = "c9617e";
        dim2 = "7cb977";
        dim3 = "cfb885";
        dim4 = "5f8ad0";
        dim5 = "cb98bd";
        dim6 = "6ab8ab";
        dim7 = "9098b4";

        selection-foreground = "cdd6f4";
        selection-background = "414356";

        search-box-no-match = "11111b f38ba8";
        search-box-match = "cdd6f4 313244";

        jump-labels = "11111b fab387";
        urls = "89b4fa";
      };
    };
  };
}
