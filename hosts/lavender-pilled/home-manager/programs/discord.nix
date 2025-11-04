{ inputs, ... }:
{
  imports = [ inputs.nixcord.homeModules.nixcord ];

  programs.nixcord = {
    enable = true;
    config = {
      plugins = {
        anonymiseFileNames = {
          enable = true;
          anonymiseByDefault = true;
          #randomisedLength = 7;
        };
        #automodContext.enable = true; # native to discord now
        callTimer.enable = true;
        clearURLs.enable = true;
        copyEmojiMarkdown.enable = true;
        dontRoundMyTimestamps.enable = true;
        expressionCloner.enable = true;
        experiments.enable = true;
        fakeNitro.enable = true;
        favoriteEmojiFirst.enable = true;
        favoriteGifSearch.enable = true;
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
        normalizeMessageLinks.enable = true;
        permissionsViewer.enable = true;
        platformIndicators = {
          enable = true;
          badges = false;
          messages = false;
        };
        relationshipNotifier.enable = true;
        roleColorEverywhere.enable = true;
        shikiCodeblocks = {
          enable = true;
          theme = "https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/refs/heads/main/packages/tm-themes/themes/catppuccin-mocha.json";
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
        #watchTogetherAdblock.enable = true; # superseded by youtubeAdblock
        youtubeAdblock.enable = true;
      };
    };
    vesktop.enable = true;

    discord.openASAR.enable = false; # openasar broken rn
  };
}
