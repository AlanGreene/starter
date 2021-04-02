#!/bin/bash

cecho "Writing defaults" $cyan

defaults write -g AppleInterfaceStyle -string "Dark"
defaults write -g AppleKeyboardUIMode -int 2
defaults write -g AppleShowScrollBars -string "WhenScrolling"

defaults write -g InitialKeyRepeat -int 15
defaults write -g KeyRepeat -int 2

defaults write -g NSAutomaticCapitalizationEnabled -bool FALSE
defaults write -g NSAutomaticDashSubstitutionEnabled -bool FALSE
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool FALSE
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool FALSE
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool FALSE
defaults write -g NSAutomaticTextCompletionEnabled -bool TRUE
defaults write -g WebAutomaticSpellingCorrectionEnabled -bool FALSE
defaults write -g NSQuitAlwaysKeepsWindows -bool TRUE
