{ config, ... }:
{
  # Okular signs PDFs with certificates from an NSS database. NSS itself only
  # knows ~/.pki/nssdb, so point Okular at one under XDG_DATA_HOME instead.
  # The database holds a private key, so it is created by hand, not here:
  #   certutil -N -d sql:$XDG_DATA_HOME/pki/nssdb
  #   pk12util -i <key>.p12 -d sql:$XDG_DATA_HOME/pki/nssdb
  # /home is not wiped on boot, so it needs no persistence entry.
  programs.plasma.configFile."okular-generator-popplerrc".Signatures = {
    UseDefaultCertDB = false;
    # Okular stores this as a URL (its settings dialog writes file://...) and
    # reads a bare path back as empty, which silently means no database.
    DBCertificatePath = "file://${config.xdg.dataHome}/pki/nssdb";
  };
}
