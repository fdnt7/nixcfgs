{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in
{
  options.programs.rebuild = {
    enable = mkEnableOption "rebuild helper script";
    hostName = mkOption {
      type =
        let
          inherit (types) either singleLineStr;
        in
        either singleLineStr builtins.path;
      description = "The name of the machine.";
    };
  };

  config =
    let
      programsCfg = config.programs;
      cfg = programsCfg.rebuild;

      git = "${programsCfg.git.package}/bin/git";
      nh = "${programsCfg.nh.package}/bin/nh";
      nix = "${pkgs.nix}/bin/nix";
      coreutils = "${pkgs.coreutils}/bin";
      script = "${pkgs.util-linux}/bin/script";
      ansi2txt = "${pkgs.colorized-logs}/bin/ansi2txt";
      awk = "${pkgs.gawk}/bin/awk";
      cmp = "${pkgs.diffutils}/bin/cmp";
      grep = "${pkgs.gnugrep}/bin/grep";
      sed = "${pkgs.gnused}/bin/sed";
      mktemp = "${coreutils}/mktemp";
      date = "${coreutils}/date";
      rm = "${coreutils}/rm";
      cat = "${coreutils}/cat";
      realpath = "${coreutils}/realpath";
      flake = "${programsCfg.nh.flake}";
      rebuildNotesRef = "refs/notes/rebuild/${cfg.hostName}";

      commonShell = ''
        git_bin='${git}'
        nh_bin='${nh}'
        nix_bin='${nix}'
        script_bin='${script}'
        ansi2txt_bin='${ansi2txt}'
        awk_bin='${awk}'
        cmp_bin='${cmp}'
        grep_bin='${grep}'
        sed_bin='${sed}'
        cat_bin='${cat}'
        date_bin='${date}'
        realpath_bin='${realpath}'
        empty_nvd='No version or size changes'
        host_name='${cfg.hostName}'
        notes_ref='${rebuildNotesRef}'

        die() {
          printf '%s\n' "$1" >&2
          exit 1
        }

        info() {
          printf '%s\n' "$1" >&2
        }

        strip_script_envelope() {
          "$ansi2txt_bin" < "$1" |
            "$sed_bin" \
              -e '/^Script started on /d' \
              -e '/^Script done on /d' \
              -e 's/\r$//'
        }

        extract_nvd_output() {
          local raw_log=$1
          local out_file=$2

          strip_script_envelope "$raw_log" |
            "$awk_bin" -v empty="$empty_nvd" '
              /^>? ?No version or size changes\.$/ {
                print empty
                found = 1
                exit
              }

              /^<<< \/run\/current-system$/ {
                capture = 1
              }

              capture {
                print
                found = 1

                if (/^DIFF: /) {
                  exit
                }
              }

              END {
                if (!found) {
                  exit 1
                }
              }
            ' > "$out_file" || die "Failed to parse the nh package diff output."
        }

        nvd_output_is_nonempty() {
          ! "$grep_bin" -Fxq "$empty_nvd" "$1"
        }

        extract_changed_paths() {
          "$git_bin" status --porcelain=v1 --untracked-files=all |
            while IFS= read -r line; do
              path="''${line:3}"

              case "$path" in
                *" -> "*)
                  printf '%s\n' "''${path%% -> *}"
                  printf '%s\n' "''${path##* -> }"
                  ;;
                *)
                  printf '%s\n' "$path"
                  ;;
              esac
            done |
            "$awk_bin" 'NF && !seen[$0]++'
        }

        extract_commit_type() {
          local rev=$1
          local subject
          local commit_type

          subject="$("$git_bin" log -1 --pretty=%s "$rev")"

          commit_type="$(
            printf '%s\n' "$subject" |
              "$sed_bin" -En 's/^([A-Za-z0-9_-]+)(\([^)]+\))?(!)?:[[:space:]].*$/\1/p'
          )"

          if [ -n "$commit_type" ]; then
            printf '%s\n' "$commit_type"
            return 0
          fi

          die "Can't infer a conventional-commit type from: $subject"
        }

        append_nvd_to_head_commit() {
          local nvd_file=$1
          local msg_file=$2

          "$git_bin" log -1 --pretty=%B > "$msg_file"
          printf '\n' >> "$msg_file"
          "$cat_bin" "$nvd_file" >> "$msg_file"
          "$git_bin" commit --amend -F "$msg_file" >/dev/null
        }

        write_git_note() {
          local subject=$1
          local body_file=$2
          local note_file=$3
          local rev=$4
          local existing_note_file=$5
          local rebuilt_at

          rebuilt_at="$("$date_bin" --iso-8601=seconds)"

          {
            printf '%s\n' "$subject"
            printf '\n'
            "$cat_bin" "$body_file"
            printf '\n\nRebuilt-at: %s\n' "$rebuilt_at"
          } > "$note_file"

          if "$git_bin" notes --ref="$notes_ref" show "$rev" > "$existing_note_file" 2>/dev/null; then
            if "$cmp_bin" -s "$existing_note_file" "$note_file"; then
              return 0
            fi

            "$git_bin" notes --ref="$notes_ref" add -f -F "$note_file" "$rev" >/dev/null 2>&1
            return 0
          fi

          "$git_bin" notes --ref="$notes_ref" add -F "$note_file" "$rev" >/dev/null
        }

        format_and_preview_dirty_commit() {
          "$nix_bin" fmt .
          "$git_bin" add -A
          "$git_bin" commit --amend --no-edit >/dev/null
          "$git_bin" diff --color=always HEAD^
        }

        run_build_and_deploy() {
          local out_link=$1
          local build_log=$2
          local nvd_file=$3
          local built_toplevel

          if ! "$script_bin" -eqfc "\"$nh_bin\" os build --diff always --out-link \"$out_link\"" "$build_log"; then
            return 1
          fi

          extract_nvd_output "$build_log" "$nvd_file"

          built_toplevel="$("$realpath_bin" "$out_link")"
          info "Activating the built generation with nh os switch --ask."
          "$nh_bin" os switch --ask --diff never "$built_toplevel"
        }
      '';
    in
    mkIf cfg.enable {
      home.packages = [
        (pkgs.writeShellScriptBin "rebuild" ''
          set -euo pipefail

          ${commonShell}

          cd '${flake}'

          temp_dir="$(${mktemp} -d -t rebuild.XXXXXX)"
          build_log="$temp_dir/build.log"
          changed_paths="$temp_dir/changed-paths"
          nvd_file="$temp_dir/nvd.txt"
          msg_file="$temp_dir/msg.txt"
          note_file="$temp_dir/note.txt"
          existing_note_file="$temp_dir/existing-note.txt"
          cleanup() {
            '${rm}' -rf "$temp_dir"
          }
          trap cleanup EXIT

          if "$git_bin" status --porcelain=v1 --untracked-files=all | "$grep_bin" -q .; then
            host_seen=0
            other_host_seen=0
            non_host_seen=0

            extract_changed_paths > "$changed_paths"

            while IFS= read -r path; do
              case "$path" in
                "hosts/$host_name/"*)
                  host_seen=1
                  ;;
                hosts/*)
                  other_host_seen=1
                  ;;
                *)
                  non_host_seen=1
                  ;;
              esac
            done < "$changed_paths"

            if [ "$host_seen" -eq 1 ] && [ "$other_host_seen" -eq 0 ] && [ "$non_host_seen" -eq 0 ]; then
              {
                printf 'FIXME_type(%s): FIXME_desc\n' "$host_name"
                printf '\n'
              } > "$msg_file"

              "$git_bin" add -A
              "$git_bin" commit -F "$msg_file" >/dev/null

              if ! format_and_preview_dirty_commit; then
                "$git_bin" reset --mixed HEAD^ >/dev/null
                die "Formatting failed. Restored the dirty tree."
              fi

              if ! run_build_and_deploy "$temp_dir/result" "$build_log" "$nvd_file"; then
                "$git_bin" reset --mixed HEAD^ >/dev/null
                die "Rebuild failed. Restored the dirty tree."
              fi

              if nvd_output_is_nonempty "$nvd_file"; then
                append_nvd_to_head_commit "$nvd_file" "$msg_file"
              fi

              "$git_bin" commit --amend
              exit 0
            fi

            if [ "$host_seen" -eq 0 ] && [ "$other_host_seen" -eq 0 ] && [ "$non_host_seen" -eq 1 ]; then
              printf 'FIXME_type(FIXME_scope): FIXME_desc\n' > "$msg_file"

              "$git_bin" add -A
              "$git_bin" commit -F "$msg_file" >/dev/null

              if ! format_and_preview_dirty_commit; then
                "$git_bin" reset --mixed HEAD^ >/dev/null
                die "Formatting failed. Restored the dirty tree."
              fi

              if ! run_build_and_deploy "$temp_dir/result" "$build_log" "$nvd_file"; then
                "$git_bin" reset --mixed HEAD^ >/dev/null
                die "Rebuild failed. Restored the dirty tree."
              fi

              "$git_bin" commit --amend
              commit_type="$(extract_commit_type HEAD)"
              write_git_note "$commit_type($host_name): rebuild" "$nvd_file" "$note_file" HEAD "$existing_note_file"
              exit 0
            fi

            printf 'Refusing to rebuild from a dirty tree because the changed paths cross unsupported boundaries.\n' >&2

            if [ "$other_host_seen" -eq 1 ]; then
              printf 'Only hosts/%s/ may be touched for host-local dirty rebuilds.\n' "$host_name" >&2
            fi

            if [ "$host_seen" -eq 1 ] && [ "$non_host_seen" -eq 1 ]; then
              printf 'Current-host changes cannot be mixed with paths outside hosts/.\n' >&2
            fi

            printf 'Changed paths:\n' >&2
            while IFS= read -r path; do
              printf '  %s\n' "$path" >&2
            done < "$changed_paths"

            exit 1
          fi

          if ! run_build_and_deploy "$temp_dir/result" "$build_log" "$nvd_file"; then
            die "Rebuild failed."
          fi

          if ! nvd_output_is_nonempty "$nvd_file" && "$git_bin" notes --ref="$notes_ref" show HEAD >/dev/null 2>&1; then
            info "No rebuild was needed; keeping the existing note on HEAD."
            exit 0
          fi

          commit_type="$(extract_commit_type HEAD)"
          write_git_note "$commit_type($host_name): rebuild" "$nvd_file" "$note_file" HEAD "$existing_note_file"
        '')

        (pkgs.writeShellScriptBin "update" ''
          set -euo pipefail

          ${commonShell}

          cd '${flake}'

          temp_dir="$(${mktemp} -d -t update.XXXXXX)"
          update_log="$temp_dir/update.log"
          update_output="$temp_dir/update-output.txt"
          changed_paths="$temp_dir/changed-paths"
          build_log="$temp_dir/build.log"
          nvd_file="$temp_dir/nvd.txt"
          msg_file="$temp_dir/msg.txt"
          note_file="$temp_dir/note.txt"
          existing_note_file="$temp_dir/existing-note.txt"
          cleanup() {
            '${rm}' -rf "$temp_dir"
          }
          trap cleanup EXIT

          if "$git_bin" status --porcelain=v1 --untracked-files=all | "$grep_bin" -q .; then
            die "update only commits flake.lock, so it must start from a clean git tree."
          fi

          if ! "$script_bin" -eqfc "\"$nix_bin\" flake update" "$update_log"; then
            die "nix flake update failed."
          fi

          strip_script_envelope "$update_log" |
            "$awk_bin" '
              /^• / {
                capture = 1
                found = 1
                print
                next
              }

              capture && /^[[:space:]]+/ {
                print
                next
              }

              capture {
                capture = 0
              }

              END {
                if (!found) {
                  exit 1
                }
              }
            ' > "$update_output" || strip_script_envelope "$update_log" > "$update_output"

          if "$git_bin" diff --quiet -- flake.lock; then
            info "flake.lock is already up to date."
            exit 0
          fi

          extract_changed_paths > "$changed_paths"

          if [ "$("$awk_bin" 'END { print NR }' "$changed_paths")" -ne 1 ] || ! "$grep_bin" -Fxq 'flake.lock' "$changed_paths"; then
            printf 'nix flake update changed more than flake.lock:\n' >&2
            while IFS= read -r path; do
              printf '  %s\n' "$path" >&2
            done < "$changed_paths"
            exit 1
          fi

          {
            printf 'build(flake.lock): update\n'
            printf '\n'
            "$cat_bin" "$update_output"
          } > "$msg_file"

          "$git_bin" add flake.lock
          "$git_bin" commit -F "$msg_file" >/dev/null

          if ! run_build_and_deploy "$temp_dir/result" "$build_log" "$nvd_file"; then
            "$git_bin" reset --mixed HEAD^ >/dev/null
            die "Rebuild failed. Restored the flake.lock update to the working tree."
          fi

          write_git_note "build($host_name): apply flake.lock update" "$nvd_file" "$note_file" HEAD "$existing_note_file"
        '')
      ];

      programs.fish.shellAbbrs = {
        a = "rebuild";
        u = "update";
      };
    };
}
