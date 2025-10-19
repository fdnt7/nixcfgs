{ config, ... }:
let
  githubPat = "home-manager/nix/settings/extra-access-tokens/github-pat";
in
{
  # this is not no-op;
  # `secrets.<key> = {};` tells sops-nix to use it
  sops.secrets.${githubPat} = { };

  nix.extraOptions = "!include ${config.sops.secrets.${githubPat}.path}";
}
