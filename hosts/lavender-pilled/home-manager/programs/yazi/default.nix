{
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
          repo = pkgs.fetchFromGitHub {
            owner = "yazi-rs";
            repo = "plugins";
            rev = "9a52857eac61ede58d11c06ca813c3fa63fe3609";
            hash = "sha256-YM53SsE10wtMqI1JGa4CqZbAgr7h62MZ5skEdAavOVA=";
          };
        in
        {
          full-border = "${repo}/full-border.yazi";
        };
      settings = {
        mgr = {
          show_hidden = true;
        };
      };
      theme = {
        indicator.preview.reversed = true;
      };
    };
    fish.shellAbbrs.l = "yy";
  };
}
