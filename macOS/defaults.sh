#!/bin/bash

cecho "Writing defaults" $cyan

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

## System Preferences ==========

## General
defaults write -g AppleInterfaceStyle -string "Dark"
defaults write -g AppleKeyboardUIMode -int 2
defaults write -g AppleShowScrollBars -string "WhenScrolling"

# Make Chrome the default browser (requires user confirmation)
open -a "Google Chrome" --args --make-default-browser

## Dock & Menu Bar
# clear the dock and set it to autohide on the right
defaults delete com.apple.dock persistent-apps
defaults delete com.apple.dock persistent-others
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock minimize-to-application -bool true
defaults write com.apple.dock orientation -string "right"
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 50

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# 13: Lock Screen
# Top left screen corner → Start screen saver
defaults write com.apple.dock wvous-tl-corner -int 5
defaults write com.apple.dock wvous-tl-modifier -int 0

defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM  HH:mm"
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
defaults write com.apple.menuextra.clock IsAnalog -bool false
defaults write com.apple.menuextra.clock Show24Hour -bool true
defaults write com.apple.menuextra.clock ShowAMPM -bool false

defaults write com.apple.Siri StatusMenuVisible -bool false

## Mission Control
# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

## Spotlight
# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
# sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes"
defaults write com.apple.spotlight orderedItems -array \
	'{"enabled" = 1;"name" = "APPLICATIONS";}' \
	'{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
	'{"enabled" = 0;"name" = "DIRECTORIES";}' \
	'{"enabled" = 0;"name" = "PDF";}' \
	'{"enabled" = 0;"name" = "FONTS";}' \
	'{"enabled" = 0;"name" = "DOCUMENTS";}' \
	'{"enabled" = 0;"name" = "MESSAGES";}' \
	'{"enabled" = 0;"name" = "CONTACT";}' \
	'{"enabled" = 0;"name" = "EVENT_TODO";}' \
	'{"enabled" = 0;"name" = "IMAGES";}' \
	'{"enabled" = 0;"name" = "BOOKMARKS";}' \
	'{"enabled" = 0;"name" = "MUSIC";}' \
	'{"enabled" = 0;"name" = "MOVIES";}' \
	'{"enabled" = 0;"name" = "PRESENTATIONS";}' \
	'{"enabled" = 0;"name" = "SPREADSHEETS";}' \
	'{"enabled" = 0;"name" = "SOURCE";}' \
	'{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
	'{"enabled" = 0;"name" = "MENU_OTHER";}' \
	'{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
	'{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
	'{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
	'{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null

## Accessibility
# Use scroll gesture with the Ctrl (^) modifier key to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess closeViewScrollWheelModifiersInt -int 262144
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

## Security & Privacy
# Require password immediately after sleep or screen saver begins
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

## Software Update
# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -bool true
# Don't auto install OS updates, system data files & security updates
defaults write com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool false
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool false
# Don't automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -bool false
# Disable app auto-update
defaults write com.apple.commerce AutoUpdate -bool false

## Keyboard
defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2
# Disable press-and-hold for keys in favor of key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

defaults write -g NSAutomaticCapitalizationEnabled -bool FALSE
defaults write -g NSAutomaticDashSubstitutionEnabled -bool FALSE
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool FALSE
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool FALSE
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool FALSE
defaults write -g NSAutomaticTextCompletionEnabled -bool TRUE
defaults write -g WebAutomaticSpellingCorrectionEnabled -bool FALSE
defaults write -g NSQuitAlwaysKeepsWindows -bool TRUE

# disable text replacment
defaults write -g NSUserDictionaryReplacementItems -array '()'
sqlite3 ~/Library/Dictionaries/CoreDataUbiquitySupport/${USER}~*/UserDictionary/*/store/UserDictionary.db "delete from ZUSERDICTIONARYENTRY;"
sqlite3 ~/Library/KeyboardServices/TextReplacements.db "delete from ZTEXTREPLACEMENTENTRY;"

## Trackpad
# Enable tap to click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
# Enable “natural” scrolling
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool true

## Sharing
# Enable Remote Login
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist

## Apps ==========

## Activity Monitor
# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
# Show all processes in Activity Monitor
defaults write com.apple.ActivityMonitor ShowCategory -int 0

## Finder (and related)
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
# Use column view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `Nlsv`, `glyv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# Set home folder as the default location for new Finder windows
# For Desktop, use `PfDe` and `file://${HOME}/Desktop/`
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file:///${HOME}/"
# Show status bar (free space etc.)
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool false
# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true
# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

## Safari
# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false
# Add a context menu item for showing the Web Inspector in web views
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true
# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string "about:blank"
# Enable the Develop menu and the Web Inspector in Safari
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true

## TextEdit
# Use plain text mode for new documents
defaults write com.apple.TextEdit RichText -bool false
# Display HTML files as HTML code instead of formatted text
defaults write com.apple.TextEdit IngoreHTML -bool true
# Don't automatically add .txt extension to files
defaults write com.apple.TextEdit AddExtensionToNewPlainTextFiles -bool false
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

## Transmission
defaults write org.m0k.transmission AutoImport -bool true
defaults write org.m0k.transmission AutoImportDirectory -string "${HOME}/Downloads"
defaults write org.m0k.transmission BindPort -int 51413
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true
defaults write org.m0k.transmission DHTGlobal -bool false
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission DownloadFolder -string "${HOME}/Downloads/torrents/complete"
defaults write org.m0k.transmission DownloadLocationConstant -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Downloads/torrents/downloading"
defaults write org.m0k.transmission MagnetOpenAsk -bool false
defaults write org.m0k.transmission PEXGlobal -bool false
defaults write org.m0k.transmission RandomPort -bool false
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission WarningDonate -bool false
defaults write org.m0k.transmission WarningLegal -bool false

## Kill any affected apps to ensure the settings are applied
for app in "Activity Monitor" \
	"cfprefsd" \
	"Dock" \
	"Finder" \
	"SystemUIServer" \
	"TextEdit"; do
	killall "${app}" &> /dev/null
done
