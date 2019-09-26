#!/bin/bash

# Mac Software Update
#softwareupdate -i -a

# Install Homebrew
if test ! $(which brew)
then
    cecho "Installing Homebrew..." $blue
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    cecho "Homebrew already installed." $green
fi

# verify Homebrew install
brew doctor

# Update Homebrew
brew update
# Upgrade any existing formulae
brew upgrade

# Link Homebrew casks in `/Applications` rather than `~/Applications`
# More configuration options available
# @see https://github.com/Homebrew/homebrew-cask/blob/master/USAGE.md#options
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# install brews - commands specified in Brewfile (e.g. tap 'homebrew/versions' \n brew 'wget' \n brew 'git')
cecho "Installing homebrew formulae..." $blue
cecho "Casks will be linked in /Applications" $cyan
brew tap homebrew/bundle
brew bundle --file=${STARTER}/osx/brew/Brewfile

# verify cask install
#brew cask doctor
#brew bundle Caskfile

cecho "Remove outdated homebrew formulae from the cellar"
brew cleanup
brew cask cleanup
