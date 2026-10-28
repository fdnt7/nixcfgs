{
  imports = [ ../../nixos/optional/openssh.nix ];

  # f, from fw16, with the key kept on f's YubiKey (application ssh:tailnet):
  # each connection asks for a touch.
  users.users.k.openssh.authorizedKeys.keys = [
    "sk-ssh-ed25519@openssh.com AAAAGnNrLXNzaC1lZDI1NTE5QG9wZW5zc2guY29tAAAAIDt6hBxuiXTp8jcbiyMkOiWdQu6jr92v6UzzNUIkoN9sAAAAC3NzaDp0YWlsbmV0 f@fw16"
  ];
}
