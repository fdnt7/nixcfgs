{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.discord = {
    enable = false;
    settings = {
      # SKIP_HOST_UPDATE = true; # `true` by default by home-manager
      WINDOW_BOUNDS = {
        height = 500;
        width = 940;
        x = 736;
        y = 0;
      };
      asyncVideoInputDeviceInit = false;
      chromiumSwitches = { };
      enableHardwareAcceleration = true;
      enableLibOpenH264Electron = false;
      offloadAdmControls = true;
      openH264Enabled = true;
      openasar = {
        setup = true;
      };
      trayBalloonShown = true;
    };
  };

  programs.discord.settings.BACKGROUND_COLOR = "#121214";
  programs.discord.settings.DANGEROUS_ENABLE_DEVTOOLS_ONLY_ENABLE_IF_YOU_KNOW_WHAT_YOURE_DOING = true;
  programs.discord.settings.IS_MAXIMIZED = true;
  programs.discord.settings.IS_MINIMIZED = false;

  programs.nixcord = {
    enable = true;
    vesktop.enable = true;
    # OpenASAR is preventing discord from starting up
    #
    # Refs: https://github.com/FlameFlag/nixcord/issues/226#issuecomment-4751549041
    discord.openASAR.enable = false;
  };

  programs.nixcord.config.plugins = {
    anonymiseFileNames = {
      enable = true;
      anonymiseByDefault = true;
      randomisedLength = 128;
    };
    callTimer.enable = true;
    clearUrls.enable = true;
    copyEmojiMarkdown.enable = true;
    dontRoundMyTimestamps.enable = true;
    expressionCloner.enable = true;
    experiments.enable = true;
    fakeNitro.enable = true;

    fixSpotifyEmbeds.enable = true;
    fixYoutubeEmbeds.enable = true;
    forceOwnerCrown.enable = true;
    friendsSince.enable = true;
    hideMedia.enable = true;
    # imageZoom.enable = true; # discord's native zoom is superior
    memberCount.enable = true;
    mentionAvatars.enable = true;
    messageClickActions = {
      enable = true;
      enableDoubleClickToEdit = false;
      enableDoubleClickToReply = false;
    };
    messageLatency.enable = true;
    messageLogger = {
      enable = true;
      collapseDeleted = true;
      deleteStyle = "overlay";
      ignoreBots = true;
      ignoreSelf = true;
      inlineEdits = false;
    };
    newGuildSettings.enable = true;
    noOnboardingDelay.enable = true;
    noUnblockToJump.enable = true;
    permissionsViewer.enable = true;
    platformIndicators = {
      enable = true;
      profiles = false;
      messages = false;
    };
    relationshipNotifier.enable = true;

    shikiCodeblocks = {
      enable = true;
      theme =
        let
          ref = "bc5436518111d87ea58eb56d97b3f9bec30e6b83";
        in
        "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/${ref}/packages/tm-themes/themes/catppuccin-mocha.json";
    };
    serverInfo.enable = true;
    showHiddenThings.enable = true;
    showTimeoutDuration.enable = true;
    sortFriendRequests.enable = true;
    spotifyCrack.enable = true;
    summaries.enable = true;
    typingIndicator.enable = true;
    typingTweaks.enable = true;
    unindent.enable = true;
    unsuppressEmbeds.enable = true;
    validReply.enable = true;
    vencordToolbox.enable = true;
    viewIcons.enable = true;
    viewRaw.enable = true;
    volumeBooster.enable = true;
    youtubeAdblock.enable = true;
  };

  programs.nixcord.config.plugins.favoriteEmojiFirst.enable = true;
  programs.nixcord.config.plugins.favoriteGifSearch.enable = true;
  programs.nixcord.config.plugins.roleColorEverywhere.enable = true;
}
