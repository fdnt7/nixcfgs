{
  programs = {
    fastfetch.enable = true;
    fish.interactiveShellInit = ''
      fastfetch --config small
    '';
  };

  xdg = {
    dataFile = {
      "fastfetch/presets".source = ./presets;
    };
  };
}
