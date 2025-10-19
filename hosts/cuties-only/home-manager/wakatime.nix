{
  config,
  lib,
  ...
}:
let
  wakatimeApiKey = "home-manager/wakatime/api_key";
in
{
  # this is not no-op;
  # `secrets.<key> = {};` tells sops-nix to use it
  sops.secrets.${wakatimeApiKey} = { };

  xdg.configFile."wakatime".text = lib.generators.toINI { } {
    settings.api_key_vault_cmd = "cat ${config.sops.secrets.${wakatimeApiKey}.path}";
  };
}
