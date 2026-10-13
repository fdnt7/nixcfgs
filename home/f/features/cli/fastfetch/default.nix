{
  # System summary, shown in short form at the top of each new shell.
  programs = {
    fastfetch.enable = true;
    fish.interactiveShellInit = ''
      fastfetch --config small
    '';
  };

  # Looked up by name, as `--config small`.
  xdg.dataFile."fastfetch/presets".source = ./presets;
}
