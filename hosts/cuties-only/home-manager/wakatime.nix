{lib, ...}: {
  xdg.configFile."wakatime".text = lib.generators.toINI {} {
    settings.api_key_vault_cmd = "cat /";
  };
}
