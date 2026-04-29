{
  # Discord packages now depend on insecure OpenSSL 1.1
  # Refs: https://github.com/NixOS/nixpkgs/issues/513122
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];

  imports = [
    ./canary.nix
    ./stable.nix
  ];
}
