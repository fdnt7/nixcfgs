{ config, ... }:
{
  users.users.f = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    hashedPasswordFile = "${config.impermanence.persist}/secrets/f.passwd";
  };
}
