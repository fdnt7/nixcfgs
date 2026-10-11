{ config, pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "wakatime"
      "discord-presence"
      "sql"
      "nix"
      "typst"
      "ruff"
      "lean4"
      "toml"
      "git-firefly"
    ];
    extraPackages = [
      pkgs.zed-discord-presence
      pkgs.zed-wakatime-ls
    ];

    # For information on how to configure Zed, see the Zed
    # documentation: https://zed.dev/docs/configuring-zed
    userSettings = {
      collaboration_panel.dock = "right";
      outline_panel.dock = "right";
      project_panel.dock = "right";
      ui_font_size = 16;
      buffer_font_size = 12;
      buffer_font_family = "JetBrainsMono Nerd Font";
      vim_mode = true;
      relative_line_numbers = "enabled";

      lsp.tinymist.settings = {
        exportPdf = "onType";
        outputPath = "$dir/$name";
      };
      diagnostics.inline.enabled = true;
      languages.Nix.language_servers = [
        "!nil"
        "..."
      ];
    };
  };

  programs.zed-editor.userSettings.lsp.rust-analyzer.initialization_options = {
    check.command = "clippy";
    cargo.features = "all";
  };

  # The WakaTime language server would otherwise write ~/.wakatime.cfg.
  home.sessionVariables.WAKATIME_HOME = "${config.xdg.configHome}/wakatime";
}
