{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  options.programs.rebuild = {
    enable = mkEnableOption "rebuild helper script";
    hostName = mkOption {
      type = with types; either singleLineStr path;
      description = "The name of the machine.";
    };
  };

  config = let
    programsCfg = config.programs;
    cfg = programsCfg.rebuild;
  in
    mkIf cfg.enable {
      home.packages = let
        git = "${programsCfg.git.package}/bin/git";
        nhCfg = programsCfg.nh;
        coreutils = "${pkgs.coreutils}/bin";
      in [
        (pkgs.writeShellScriptBin "rebuild" ''
          set -euo pipefail

          # Work in the flake directory
          cd "${nhCfg.flake}"

          # 1) Format and show diff; only page if needed, requiring user input then.
          "${git}" add .
          "${git}" commit --allow-empty -m "type(${cfg.hostName}): message"
          "${pkgs.nix}/bin/nix" fmt .

          # 2) Stage and make a non-interactive commit
          "${git}" add .
          "${git}" commit --amend --no-edit
          "${git}" diff --color=always @^

          # 3) Run nh; tee stdout to file 'o' while still printing to real stdout
          o="$(${coreutils}/mktemp -t rebuild-nh.XXXXXX)"
          cleaned="$(${coreutils}/mktemp -t rebuild-clean.XXXXXX)"
          msg="$(${coreutils}/mktemp -t rebuild-msg.XXXXXX)"
          cleanup() { "${coreutils}/rm" -f "$o" "$cleaned" "$msg"; }
          trap cleanup EXIT

          set -o pipefail

          if "${pkgs.util-linux}/bin/script" -qc '"${nhCfg.package}/bin/nh" os switch --ask' "$o" &&
            "${pkgs.colorized-logs}/bin/ansi2txt" < "$o" |
            "${pkgs.gnused}/bin/sed" -n '/^<<< \/run\/current-system$/,/^DIFF: .*$/p' > "$cleaned"; then

            # Success: amend commit with contents of 'o', then open editor for final tweaks
            "${git}" log -1 --pretty=%B > "$msg"
            echo >> "$msg"
            "${coreutils}/cat" "$cleaned" >> "$msg"

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
