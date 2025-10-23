# Add your reusable home-manager modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  battery-notifier = import ./battery-notifier.nix;
  devenv = import ./devenv.nix;
  rebuild = import ./rebuild.nix;
  secrets = import ./secrets.nix;
  xdg-ninja = import ./xdg-ninja.nix;
}
