{
  imports = [
    ./global

    # The terminal and development tools are f's, followed as they are.
    ../f/features/cli
    ./features/cli/git-abbreviations.nix
    ./features/cli/nix-tools.nix

    # Plasma brings its own shell, file manager, viewers and clipboard, so
    # only the programs are taken from f's desktop features.
    ../f/features/desktop/discord.nix
    ../f/features/desktop/fonts.nix
    ../f/features/desktop/foot.nix
    ../f/features/desktop/mullvad.nix
    ../f/features/desktop/zed-editor.nix
    ../f/features/desktop/zen-browser.nix

    ./features/desktop/fonts-thai-cjk.nix
    ./features/desktop/haruna.nix
    ./features/desktop/line.nix
    ./features/desktop/obs-studio.nix
    ./features/desktop/tailscale-systray.nix
    ./features/desktop/xournalpp.nix
  ];
}
