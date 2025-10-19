{ nixcfgs, ... }:
{
  programs = {
    git =
      let
        userName = "${nixcfgs.uname}7";
        userEmail = "43757589+${userName}@users.noreply.github.com";
      in
      {
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

    fish.shellAbbrs = {
      g = "git";
      gg = "git clone";
      gf = "git fetch";
      gp = "git push";
      gpf = "git push --force-with-lease";
      gpu = "git push -u";
      gu = "git pull";
      gur = "git pull --rebase";
      gl = "git log";
      glo = "git log --oneline";
      gd = "git diff";
      ga = "git add";
      "ga." = "git add .";
      gm = "git merge";
      gms = "git merge --squash";
      gc = "git commit";
      gca = "git commit --amend";
      gs = "git status";
      gb = "git branch";
      gbd = "git branch -d";
      gbm = "git branch -m";
      gw = "git switch";
      gwc = "git switch -c";
      gwm = "git switch main";
      gh = "git show";
      gt = "git stash";
      gtl = "git stash list";
      gtp = "git stash pop";
      gv = "git revert";
      gr = "git reset";
      grh = "git reset --hard";
      ge = "git rebase";
      gei = "git rebase -i";
      # no 'go' because go is a programming language
      gov = "git remote -v";
      goh = "git remote show";
      gog = "git remote get-url";
      gos = "git remote set-url";
      goa = "git remote add";
      gor = "git remote remove";
      gk = "git checkout";
    };
  };

  catppuccin.delta.enable = true;
}
