{
  config,
  lib,
  pkgs,
  nixcfgs,
  ...
}:
with lib; {
  options.programs.rebuild.enable = mkEnableOption "rebuild helper script";

  config = mkIf config.programs.rebuild.enable {
    home.packages = with nixcfgs; let
      git = "${config.programs.git.package}/bin/git";
      coreutils = "${pkgs.coreutils}/bin";
    in [
      (pkgs.writeShellScriptBin "rebuild" ''
        set -euo pipefail

        # Work in the flake directory
        cd "${flake}"

        # 1) Format and show diff; only page if needed, requiring user input then.
        "${pkgs.nix}/bin/nix" fmt .
        "${git}" diff --color=always

        # 2) Stage and make a non-interactive commit
        "${git}" add .
        "${git}" commit --allow-empty -m "type(${hostName}): message"

        # 3) Run nh; tee stdout to file 'o' while still printing to real stdout
        o="$(${coreutils}/mktemp -t rebuild-nh.XXXXXX)"
        msg="$(${coreutils}/mktemp -t rebuild-msg.XXXXXX)"
        cleanup() { "${coreutils}/rm" -f "$o" "$msg"; }
        trap cleanup EXIT

        set -o pipefail
        if "${config.programs.nh.package}/bin/nh" os switch --ask | "${coreutils}/tee" "$o"; then
          # Success: amend commit with contents of 'o', then open editor for final tweaks
          "${git}" log -1 --pretty=%B > "$msg"
          echo >> "$msg"
          "${coreutils}/cat" "$o" >> "$msg"

          "${git}" commit --amend -F "$msg"
          "${git}" commit --amend
        else
          # Failure: undo the last commit and make the working tree dirty again
          "${git}" reset --mixed HEAD^
          exit 1
        fi
      '')
    ];

    programs.fish.shellAbbrs.a = "rebuild";
  };
}
