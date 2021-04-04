#!/bin/bash

cecho "Writing defaults" $cyan

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

defaults write -g AppleInterfaceStyle -string "Dark"
defaults write -g AppleKeyboardUIMode -int 2
defaults write -g AppleShowScrollBars -string "WhenScrolling"

defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

defaults write -g NSAutomaticCapitalizationEnabled -bool FALSE
defaults write -g NSAutomaticDashSubstitutionEnabled -bool FALSE
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool FALSE
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool FALSE
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool FALSE
defaults write -g NSAutomaticTextCompletionEnabled -bool TRUE
defaults write -g WebAutomaticSpellingCorrectionEnabled -bool FALSE
defaults write -g NSQuitAlwaysKeepsWindows -bool TRUE

# clear the dock and set it to autohide on the right
defaults delete com.apple.dock persistent-apps
defaults delete com.apple.dock persistent-others
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock minimize-to-application -bool true
# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false
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

killall Dock
