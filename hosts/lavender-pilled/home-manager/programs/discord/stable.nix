{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;
    vesktop.enable = true;
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
