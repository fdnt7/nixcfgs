{
  config,
  inputs,
  pkgs,
  ...
}:
{
  nix.settings = {
    extra-substituters = [ "https://yazi.cachix.org" ];
    extra-trusted-public-keys = [ "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k=" ];
  };

  programs = {
    yazi = {
      enable = true;
      package = inputs.yazi.packages.${pkgs.stdenv.hostPlatform.system}.default;
      enableFishIntegration = true;
      initLua = ./init.lua;
      plugins =
        let
          yaziPlugins = pkgs.fetchFromGitHub {
            owner = "yazi-rs";
            repo = "plugins";
            rev = "ac82af3e10f9a32cecd9f87ac64b3f9de7c7aea7";
            hash = "sha256-svc7I2E+tVMEUWUvIS6i3oTGfLq13eaI61T0c1MQ8qQ=";
          };
        in
        {
          # full-border = pkgs.yaziPlugins.full-border;
          full-border = "${yaziPlugins}/full-border.yazi";
        };
      settings = {
        mgr = {
          show_hidden = true;
        };
      };
      theme = {
        indicator.preview.reversed = true;
        status = {
          sep_left = {
            open = "";
            close = "";
          };
          sep_right = {
            open = "";
            close = "";
          };
        };
      };
      shellWrapperName = "y";
    };
    fish.shellAbbrs.l = config.programs.yazi.shellWrapperName;
  };
}
