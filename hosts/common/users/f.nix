{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  users.users.f = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [
      "wheel"
      "networkmanager"
    ]
    ++ lib.optional config.security.tpm2.enable config.security.tpm2.tssGroup;
    hashedPasswordFile = "${config.impermanence.persist}/secrets/f.passwd";
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.f = import ../../../home/f/${config.networking.hostName}.nix;
  };
}
