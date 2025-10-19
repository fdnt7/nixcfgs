{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.programs.rebuild = {
    enable = mkEnableOption "rebuild helper script";
    hostName = mkOption {
      type = with types; either singleLineStr path;
      description = "The name of the machine.";
    };
  };

  config =
    let
      programsCfg = config.programs;
      cfg = programsCfg.rebuild;
    in
    mkIf cfg.enable {
      home.packages =
        let
          git = "\"${programsCfg.git.package}/bin/git\"";
          nhCfg = programsCfg.nh;
          coreutils = "${pkgs.coreutils}/bin";
          script = "\"${pkgs.util-linux}/bin/script\"";
          ansi2txt = "\"${pkgs.colorized-logs}/bin/ansi2txt\"";
          sed = "\"${pkgs.gnused}/bin/sed\"";
          flake = "\"${nhCfg.flake}\"";
          cat = "\"${coreutils}/cat\"";
          mktemp = "${coreutils}/mktemp";
          rm = "\"${coreutils}/rm\"";
        in
        [
          (pkgs.writeShellScriptBin "rebuild" ''
            set -euo pipefail

            # Work in the flake directory
            cd ${flake}

            # 1) Format and show diff; only page if needed, requiring user input then.
            ${git} add .
            ${git} commit -m "type(${cfg.hostName}): message"
            "${pkgs.nix}/bin/nix" fmt .

            # 2) Stage and make a non-interactive commit
            ${git} add .
            ${git} commit --amend --no-edit
            ${git} diff --color=always @^

            # 3) Run nh; tee stdout to file 'o' while still printing to real stdout
            o="$(${mktemp} -t rebuild-nh.XXXXXX)"
            cleaned="$(${mktemp} -t rebuild-clean.XXXXXX)"
            msg="$(${mktemp} -t rebuild-msg.XXXXXX)"
            cleanup() { ${rm} -f "$o" "$cleaned" "$msg"; }
            trap cleanup EXIT

            set -o pipefail

            # Run nh via script, log to $o
            ${script} -qc '"${nhCfg.package}/bin/nh" os switch --ask' "$o"

            # Extract nh exit code from the log footer
            nh_status="$("${pkgs.gnugrep}/bin/grep" -o 'COMMAND_EXIT_CODE="[0-9]\+"' "$o" | ${sed} 's/.*="\([0-9]\+\)"/\1/')"

            if [ "$nh_status" -eq 0 ]; then
              # Success branch
              ${ansi2txt} < "$o" |
                ${sed} -n '/^<<< \/run\/current-system$/,/^DIFF: .*$\|^> No version or size changes\.$/p' > "$cleaned"

              ${git} log -1 --pretty=%B > "$msg"
              echo >> "$msg"
              ${cat} "$cleaned" >> "$msg"

              ${git} commit --amend -F "$msg"
              ${git} commit --amend
            else
              # Failure branch: undo last commit
              ${git} reset --mixed @^
              exit 1
            fi
          '')

          (pkgs.writeShellScriptBin "update" ''
            cd ${flake}

            o="$(${mktemp} -t update-nh.XXXXXX)"
            cleaned="$(${mktemp} -t update-clean.XXXXXX)"
            msg="$(${mktemp} -t update-msg.XXXXXX)"
            cleanup() { ${rm} -f "$o" "$cleaned" "$msg"; }
            trap cleanup EXIT

            ${script} -qc 'nix flake update' $o &&
              ${ansi2txt} < $o |
              ${sed} -n '/• Updated input/{N;N;p}' > $cleaned

            if ${git} diff --quiet -- flake.lock; then
              echo "No changes in flake.lock, skipping commit."
            else
              echo "chore(flake.lock): update" >> "$msg"
              echo >> "$msg"
              ${cat} "$cleaned" >> "$msg"
              echo >> "$msg"
              ${git} add flake.lock
              ${git} commit -F "$msg"

              # Run nh via script, log to $o
              ${script} -qc '"${nhCfg.package}/bin/nh" os switch --ask' "$o"

              # Extract nh exit code from the log footer
              nh_status="$("${pkgs.gnugrep}/bin/grep" -o 'COMMAND_EXIT_CODE="[0-9]\+"' "$o" | ${sed} 's/.*="\([0-9]\+\)"/\1/')"

              if [ "$nh_status" -eq 0 ]; then
                # Success branch
                ${ansi2txt} < "$o" |
                  ${sed} -n '/^<<< \/run\/current-system$/,/^DIFF: .*$\|^> No version or size changes\.$/p' > "$cleaned"

                ${git} log -1 --pretty=%B > "$msg"
                echo >> "$msg"
                ${cat} "$cleaned" >> "$msg"

                ${git} commit --amend -F "$msg"
              else
                # Failure branch: undo last commit
                ${git} reset --hard @^
                exit 1
              fi
            fi
          '')
        ];

      programs.fish.shellAbbrs = {
        a = "rebuild";
        u = "update";
      };
    };
}
