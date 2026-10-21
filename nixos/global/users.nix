{
  # /etc/shadow does not survive a reboot, so users are declared in
  # ../users and their password hashes live on the persistent volume.
  users.mutableUsers = false;
}
