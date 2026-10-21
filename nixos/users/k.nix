{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  users.users.k = {
    isNormalUser = true;
    uid = 1000;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "networkmanager"
    ]
    ++ lib.optional config.security.tpm2.enable config.security.tpm2.tssGroup;
    hashedPasswordFile = "${config.impermanence.persist}/secrets/k.passwd";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.k = import ../../home/k/${config.networking.hostName}.nix;
  };
}
