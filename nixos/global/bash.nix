{
  # Bash stays the system shell for root and scripts. Keep its history out
  # of ~ for everyone, whichever shell they log in with.
  programs.bash.interactiveShellInit = ''
    HISTFILE="''${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"
    mkdir -p "$(dirname "$HISTFILE")"
  '';
}
