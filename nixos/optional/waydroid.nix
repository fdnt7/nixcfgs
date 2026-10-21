{ config, ... }:
{
  # Android in a container, for apps without a desktop version. The system
  # image is downloaded once with `waydroid init`; each user's Android data
  # is under ~/.local/share/waydroid.
  virtualisation.waydroid.enable = true;

  environment.persistence.${config.impermanence.persist}.directories = [ "/var/lib/waydroid" ];
}
