{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkMerge;
  cfg = config.xdg-ninja;
in
{
  options = {
    xdg-ninja = {
      enable = mkEnableOption "xdg-ninja, a shell script which checks your $HOME for unwanted files and directories.";
      installPackage = mkEnableOption "installation of xdg-ninja";
    };

    nix.useXdgBaseDirectories = mkEnableOption "usage of xdg base directories for nix";

    programs = {
      android.useXdgBaseDirectories = mkEnableOption "usage of xdg base directories for android";
      bash.useXdgBaseDirectories = mkEnableOption "usage of xdg base directories for bash";
      cargo.useXdgBaseDirectories = mkEnableOption "usage of xdg base directories for cargo";
      gtk-2.useXdgBaseDirectories = mkEnableOption "usage of xdg base directories for gtk-2";
      wget.useXdgBaseDirectories = mkEnableOption "usage of xdg base directories for wget";
    };
  };

  config = mkIf cfg.enable (
    mkMerge [
      (mkIf cfg.installPackage)
      {
        home.packages = [
          inputs.xdg-ninja.packages.${pkgs.stdenv.hostPlatform.system}.xdg-ninja
        ];
      }

      (mkIf cfg.nix.useXdgBaseDirectories)
      {
        nix.settings.use-xdg-base-directories = true;
      }
    ]
    ++ (
      let
        inherit (config.xdg) dataHome stateHome configHome;
        inherit (cfg.programs)
          android
          bash
          cargo
          gtk-2
          wget
          ;
      in
      [
        (mkIf android.useXdgBaseDirectories)
        {
          home.sessionVariables.ANDROID_USER_HOME = "${dataHome}/android";
        }

        (mkIf bash.useXdgBaseDirectories)
        {
          home.sessionVariables.HISTFILE = "${stateHome}/bash/history";
        }

        (mkIf cargo.useXdgBaseDirectories)
        {
          home.sessionVariables.CARGO_HOME = "${dataHome}/cargo";
        }

        (mkIf gtk-2.useXdgBaseDirectories)
        {
          # home-manager already provides this
          # it's equivalent to `home.sessionVariables.GTK2_RC_FILES = <cfg>;`
          gtk.gtk2.configLocation = "${configHome}/gtk-2.0/gtkrc";
        }

        (mkIf wget.useXdgBaseDirectories)
        {
          programs.fish.shellAliases.wget = "wget --hsts-file=${dataHome}/wget-hsts";
        }
      ]
    )
  );
}
