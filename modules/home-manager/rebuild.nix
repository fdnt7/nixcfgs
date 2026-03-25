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

      commonRuntimeInputs = [
        programsCfg.git.package
        programsCfg.nh.package
        pkgs.nix
        pkgs.util-linux
        pkgs.colorized-logs
        pkgs.gawk
        pkgs.diffutils
        pkgs.gnugrep
        pkgs.gnused
        pkgs.coreutils
      ];
      flake = "${programsCfg.nh.flake}";
      rebuildNotesRef = "refs/notes/rebuild/${cfg.hostName}";

      commonShell = ''
        empty_nvd='No version or size changes'
        host_name='${cfg.hostName}'
        notes_ref='${rebuildNotesRef}'
        helper_name=helper

        if [ -t 2 ] && [ -z "''${NO_COLOR-}" ]; then
          helper_info_color="$(printf '\033[1;36m')"
          helper_error_color="$(printf '\033[1;31m')"
          helper_reset_color="$(printf '\033[0m')"
        else
          helper_info_color=
          helper_error_color=
          helper_reset_color=
        fi

        helper_log() {
          local color=$1
          shift

          printf '%b[%s]%b %s\n' "$color" "$helper_name" "$helper_reset_color" "$*" >&2
        }

        die() {
          helper_log "$helper_error_color" "$1"
          exit 1
        }

        info() {
          helper_log "$helper_info_color" "$1"
        }

        error() {
          helper_log "$helper_error_color" "$1"
        }

        strip_script_envelope() {
          ansi2txt < "$1" |
            sed \
              -e '/^Script started on /d' \
              -e '/^Script done on /d' \
              -e 's/\r$//'
        }

        extract_nvd_output() {
          local raw_log=$1
          local out_file=$2

          strip_script_envelope "$raw_log" |
            awk -v empty="$empty_nvd" '
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
          ! grep -Fxq "$empty_nvd" "$1"
        }

        should_skip_activation_for_existing_note() {
          local nvd_file=$1
          local rev=''${2-}

          [ -n "$rev" ] || return 1
          ! nvd_output_is_nonempty "$nvd_file" && git notes --ref="$notes_ref" show "$rev" >/dev/null 2>&1
        }

        extract_changed_paths() {
          git status --porcelain=v1 --untracked-files=all |
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
            awk 'NF && !seen[$0]++'
        }

        extract_commit_type() {
          local rev=$1
          local subject
          local commit_type

          subject="$(git log -1 --pretty=%s "$rev")"

          commit_type="$(
            printf '%s\n' "$subject" |
              sed -En 's/^([A-Za-z0-9_-]+)(\([^)]+\))?(!)?:[[:space:]].*$/\1/p'
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

          git log -1 --pretty=%B > "$msg_file"
          printf '\n' >> "$msg_file"
          cat "$nvd_file" >> "$msg_file"
          git commit --amend -F "$msg_file" >/dev/null
        }

        write_git_note() {
          local subject=$1
          local body_file=$2
          local note_file=$3
          local rev=$4
          local existing_note_file=$5
          local rebuilt_at

          rebuilt_at="$(date --iso-8601=seconds)"

          {
            printf '%s\n' "$subject"
            printf '\n'
            cat "$body_file"
            printf '\n\nRebuilt-at: %s\n' "$rebuilt_at"
          } > "$note_file"

          if git notes --ref="$notes_ref" show "$rev" > "$existing_note_file" 2>/dev/null; then
            if cmp -s "$existing_note_file" "$note_file"; then
              return 0
            fi

            git notes --ref="$notes_ref" add -f -F "$note_file" "$rev" >/dev/null 2>&1
            return 0
          fi

          git notes --ref="$notes_ref" add -F "$note_file" "$rev" >/dev/null
        }

        format_and_preview_dirty_commit() {
          nix fmt .
          git add -A
          git commit --amend --no-edit >/dev/null
          git diff --color=always HEAD^
        }

        run_build_and_deploy() {
          local out_link=$1
          local build_log=$2
          local nvd_file=$3
          local note_rev=''${4-}
          local activation_skip_var=''${5-}
          local built_toplevel

          if [ -n "$activation_skip_var" ]; then
            printf -v "$activation_skip_var" '%s' 0
          fi

          if ! script -eqfc "nh os build --diff always --out-link \"$out_link\"" "$build_log"; then
            return 1
          fi

          extract_nvd_output "$build_log" "$nvd_file"

          if should_skip_activation_for_existing_note "$nvd_file" "$note_rev"; then
            if [ -n "$activation_skip_var" ]; then
              printf -v "$activation_skip_var" '%s' 1
            fi
            info "No rebuild was needed and this host already has a note on $note_rev; skipping activation."
            return 0
          fi

          built_toplevel="$(realpath "$out_link")"
          info "Activating the built generation with nh os switch --ask."
          nh os switch --ask --diff never "$built_toplevel"
        }
      '';
    in
    mkIf cfg.enable {
      home.packages = [
        (pkgs.writeShellApplication {
          name = "rebuild";
          runtimeInputs = commonRuntimeInputs;
          text = ''
            set -euo pipefail

            ${commonShell}
            helper_name=rebuild

            cd '${flake}'

            temp_dir="$(mktemp -d -t rebuild.XXXXXX)"
            build_log="$temp_dir/build.log"
            changed_paths="$temp_dir/changed-paths"
            nvd_file="$temp_dir/nvd.txt"
            msg_file="$temp_dir/msg.txt"
            note_file="$temp_dir/note.txt"
            existing_note_file="$temp_dir/existing-note.txt"
            cleanup() {
              rm -rf "$temp_dir"
            }
            trap cleanup EXIT

            if git status --porcelain=v1 --untracked-files=all | grep -q .; then
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

                git add -A
                git commit -F "$msg_file" >/dev/null

                if ! format_and_preview_dirty_commit; then
                  git reset --mixed HEAD^ >/dev/null
                  die "Formatting failed. Restored the dirty tree."
                fi

                if ! run_build_and_deploy "$temp_dir/result" "$build_log" "$nvd_file" HEAD; then
                  git reset --mixed HEAD^ >/dev/null
                  die "Rebuild failed. Restored the dirty tree."
                fi

                if nvd_output_is_nonempty "$nvd_file"; then
                  append_nvd_to_head_commit "$nvd_file" "$msg_file"
                fi

                git commit --amend
                exit 0
              fi

              if [ "$host_seen" -eq 0 ] && [ "$other_host_seen" -eq 0 ] && [ "$non_host_seen" -eq 1 ]; then
                printf 'FIXME_type(FIXME_scope): FIXME_desc\n' > "$msg_file"

                git add -A
                git commit -F "$msg_file" >/dev/null

                if ! format_and_preview_dirty_commit; then
                  git reset --mixed HEAD^ >/dev/null
                  die "Formatting failed. Restored the dirty tree."
                fi

                if ! run_build_and_deploy "$temp_dir/result" "$build_log" "$nvd_file" HEAD; then
                  git reset --mixed HEAD^ >/dev/null
                  die "Rebuild failed. Restored the dirty tree."
                fi

                git commit --amend
                commit_type="$(extract_commit_type HEAD)"
                write_git_note "$commit_type($host_name): rebuild" "$nvd_file" "$note_file" HEAD "$existing_note_file"
                exit 0
              fi

              error "Refusing to rebuild from a dirty tree because the changed paths cross unsupported boundaries."

              if [ "$other_host_seen" -eq 1 ]; then
                error "Only hosts/$host_name/ may be touched for host-local dirty rebuilds."
              fi

              if [ "$host_seen" -eq 1 ] && [ "$non_host_seen" -eq 1 ]; then
                error "Current-host changes cannot be mixed with paths outside hosts/."
              fi

              error "Changed paths:"
              while IFS= read -r path; do
                error "  $path"
              done < "$changed_paths"

              exit 1
            fi

            activation_was_skipped=0
            if ! run_build_and_deploy "$temp_dir/result" "$build_log" "$nvd_file" HEAD activation_was_skipped; then
              die "Rebuild failed."
            fi

            if [ "$activation_was_skipped" -eq 1 ]; then
              exit 0
            fi

            commit_type="$(extract_commit_type HEAD)"
            write_git_note "$commit_type($host_name): rebuild" "$nvd_file" "$note_file" HEAD "$existing_note_file"
          '';
        })

        (pkgs.writeShellApplication {
          name = "update";
          runtimeInputs = commonRuntimeInputs;
          text = ''
            set -euo pipefail

            ${commonShell}
            helper_name=update

            cd '${flake}'

            temp_dir="$(mktemp -d -t update.XXXXXX)"
            update_log="$temp_dir/update.log"
            update_output="$temp_dir/update-output.txt"
            changed_paths="$temp_dir/changed-paths"
            build_log="$temp_dir/build.log"
            nvd_file="$temp_dir/nvd.txt"
            msg_file="$temp_dir/msg.txt"
            note_file="$temp_dir/note.txt"
            existing_note_file="$temp_dir/existing-note.txt"
            cleanup() {
              rm -rf "$temp_dir"
            }
            trap cleanup EXIT

            if git status --porcelain=v1 --untracked-files=all | grep -q .; then
              die "update only commits flake.lock, so it must start from a clean git tree."
            fi

            if ! script -eqfc 'nix flake update' "$update_log"; then
              die "nix flake update failed."
            fi

            strip_script_envelope "$update_log" |
              awk '
                {
                  sub(/\r.*/, "")
                }

                /^• / {
                  capture = 1
                  found = 1
                  print
                  next
                }

                capture && (/^    / || /^  → /) {
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

            if git diff --quiet -- flake.lock; then
              info "flake.lock is already up to date."
              exit 0
            fi

            extract_changed_paths > "$changed_paths"

            if [ "$(awk 'END { print NR }' "$changed_paths")" -ne 1 ] || ! grep -Fxq 'flake.lock' "$changed_paths"; then
              error "nix flake update changed more than flake.lock:"
              while IFS= read -r path; do
                error "  $path"
              done < "$changed_paths"
              exit 1
            fi

            {
              printf 'build(flake.lock): update\n'
              printf '\n'
              cat "$update_output"
            } > "$msg_file"

            git add flake.lock
            git commit -F "$msg_file" >/dev/null

            if ! run_build_and_deploy "$temp_dir/result" "$build_log" "$nvd_file"; then
              git reset --mixed HEAD^ >/dev/null
              die "Rebuild failed. Restored the flake.lock update to the working tree."
            fi

            write_git_note "build($host_name): apply flake.lock update" "$nvd_file" "$note_file" HEAD "$existing_note_file"
          '';
        })
      ];

      programs.fish.shellAbbrs = {
        a = "rebuild";
        u = "update";
      };
    };
}
