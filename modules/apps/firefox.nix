{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.kFirefox;
in {
  options.kFirefox = {
    enable = lib.mkEnableOption "enable firefox";
  };

  config = lib.mkIf cfg.enable {
    programs = {
      firefox = {
        enable = true;
        package = pkgs.firefox;
        nativeMessagingHosts = {
          packages = [pkgs.firefoxpwa];
        };
        policies = {
          AutofillAddressEnabled = false;
          AutofillCreditCardEnabled = false;
          DisableAccounts = true;
          DisableFirefoxAccounts = true;
          DisableFirefoxScreenshots = true;
          DisableFirefoxStudies = true;
          DisableMasterPasswordCreation = true;
          DisablePocket = true;
          DisableTelemetry = true;
          DisplayBookmarksToolbar = "never"; # alternatives: "always" or "newtab"
          DisplayMenuBar = "default-off"; # alternatives: "always", "never" or "default-on"
          DontCheckDefaultBrowser = true;
          HardwareAcceleration = true;
          OfferToSaveLogins = false;
          OverrideFirstRunPage = "";
          OverridePostUpdatePage = "";
          PasswordManagerEnabled = false;
          PictureInPicture = true;
          PromptForDownloadLocation = false;
          SearchBar = "unified"; # alternative: "separate"
          SearchSuggestEnabled = true;
          ShowHomeButton = false;
          StartDownloadsInTempDirectory = true;
          SanitizeOnShutdown = {
            Cache = true;
            FormData = true;
            Sessions = true;
            Cookies = false;
            History = false;
            SiteSettings = false;
            Locked = true;
          };
          EnableTrackingProtection = {
            Value = true;
            Cryptomining = true;
            Fingerprinting = true;
            Locked = true;
          };
          FirefoxHome = {
            Search = true;
            TopSites = true;
            SponsoredTopSites = false;
            Highlights = false;
            Pocket = false;
            SponsoredPocket = false;
            Snippets = false;
            Locked = true;
          };
          FirefoxSuggest = {
            WebSuggestions = true;
            SponsoredSuggestions = false;
            ImproveSuggest = false;
            Locked = true;
          };
          Homepage = {
            URL = "https://glance.littlevibe.net";
            StartPage = "homepage-locked"; # alternatives: "none", "homepage", "previous-session", "homepage-locked"
            Locked = false;
          };

          # Check about:config for options.
          Preferences = {
            "browser.contentblocking.category" = {
              Value = "strict";
              Locked = true;
            };
            "browser.ctrlTab.sortByRecentlyUsed" = {
              Value = true;
              Locked = true;
            };
            "browser.ml.chat.provider" = {
              Value = "https://chatgpt.com";
              Locked = true;
            };
            "browser.preferences.expiremental.hidden" = {
              Value = false;
              Locked = true;
            };
            "browser.warnOnQuitShortcut" = {
              Value = false;
              Locked = true;
            };
            "dom.security.https_only_mode" = {
              Value = true;
              Locked = true;
            };
            "general.autoScroll" = {
              Value = true;
              Locked = true;
            };
            "sidebar.revamp" = {
              Value = true;
              Locked = false;
            };
            "sidebar.verticalTabs" = {
              Value = true;
              Locked = false;
            };
          };

          # Check about:support for extension/add-on ID strings.
          # Valid strings for installation_mode are "allowed", "blocked", "force_installed", and "normal_installed".
          ExtensionSettings = {
            "*".installation_mode = "blocked"; # blocks all addons except the ones specified below
            # Bitwarden
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden_password_manager/latest.xpi";
              installation_mode = "force_installed";
            };
            # Obsidian Web Clipper
            "clipper@obsidian.md" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/web_clipper_obsidian/latest.xpi";
              installation_mode = "force_installed";
            };
            # Wakatime
            "addons@wakatime.com" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/wakatimes/latest.xpi";
              installation_mode = "force_installed";
            };

            # ---- AdBlocking ----
            # uBlock Origin
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/uborigin/latest.xpi";
              installation_mode = "force_installed";
              private_browsing = true;
            };
            # SponsorBlock
            "sponsorBlocker@ajay.app" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/sponsorblock/latest.xpi";
              installation_mode = "force_installed";
            };

            # ---- Privacy ----
            # ClearURLs
            "{74145f27-f039-47ce-a470-a662b129930a}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
              installation_mode = "force_installed";
            };
            # Privacy Badger
            "jid1-MnnxcxisBPnSXQ@jetpack" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
              installation_mode = "force_installed";
            };
            # LocalCDN
            "{b86e4813-687a-43e6-ab65-0bde4ab75758}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/localcdn_fork_of_decentraleyes/latest.xpi";
              installation_mode = "force_installed";
            };
          };
        };
      };
    };
  };
}
