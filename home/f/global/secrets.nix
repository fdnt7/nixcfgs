{ config, inputs, ... }:
let
  token = config.sops.secrets."nix/access-tokens".path;
in
{
  # f's own secrets, kept encrypted in ../secrets.yaml to f's age key alone,
  # and decrypted with it at login. Edit with
  #   sops edit home/f/secrets.yaml
  # from the repository's root, where .sops.yaml says whom to encrypt for.
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    defaultSopsFile = ../secrets.yaml;

    # A whole nix.conf line, `access-tokens = github.com=<token>`: a token
    # with no permissions on public repositories, which lifts GitHub's limit
    # of 60 requests an hour for fetching flake inputs to 5000.
    secrets."nix/access-tokens" = { };
  };

  # `!include` passes over a missing file, so nix works as before until the
  # secret is decrypted.
  nix.extraOptions = "!include ${token}";
}
