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
      package = inputs.yazi.packages.${pkgs.system}.default;
      enableFishIntegration = true;
      initLua = ./init.lua;
      plugins =
        let
          repo = pkgs.fetchFromGitHub {
            owner = "yazi-rs";
            repo = "plugins";
            rev = "109b13df29f4b7d14fd8e1b38414b205e706c761";
            hash = "sha256-u8gbZnA8xShsbH06yCZM/aXskMrSHKPcQtIMFp1Cdyo=";
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
    };
    fish.shellAbbrs.l = "yy";
  };

  catppuccin.yazi.enable = true;
}
