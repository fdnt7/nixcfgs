{nixcfgs, ...}: {
  programs.git = let
    userName = "${nixcfgs.uname}7";
    userEmail = "43757589+${userName}@users.noreply.github.com";
  in {
    enable = true;
    delta.enable = true;
    signing = {
      format = "ssh";
      key = "~/.ssh/id_ed25519_github_${userName}_signing";
      signByDefault = true;
    };
    userEmail = userEmail;
    userName = userName;
  };

  catppuccin.delta.enable = true;
}
