{ config, ... }:
{
  # Photo and video library, with its own PostgreSQL database and Redis.
  # Reachable from other devices on the network, such as a phone's app.
  services.immich = {
    enable = true;
    host = "0.0.0.0";
    openFirewall = true;

    # How many images are worked on at once. The image library runs each
    # one on a thread from Node's pool, which holds four by default: the
    # job concurrency set in Immich has no effect beyond that. This is
    # the ceiling; that setting picks how much of it to use.
    environment.UV_THREADPOOL_SIZE = "24";
  };

  # The library, the thumbnails and model cache, and the database.
  environment.persistence.${config.impermanence.persist}.directories = [
    {
      directory = "/var/lib/immich";
      user = "immich";
      group = "immich";
      mode = "0750";
    }
    {
      directory = "/var/cache/immich";
      user = "immich";
      group = "immich";
      mode = "0755";
    }
    {
      directory = "/var/lib/postgresql";
      user = "postgres";
      group = "postgres";
      mode = "0700";
    }
  ];
}
