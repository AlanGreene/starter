#!/bin/bash

# Mac Software Update
#softwareupdate -i -a

# Install Homebrew
if test ! $(which brew)
then
    cecho "Installing Homebrew..." $blue
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    cecho "Homebrew already installed." $green
fi

brew analytics off

# verify Homebrew install
brew doctor

# Update Homebrew
brew update
# Upgrade any existing formulae
brew upgrade

# install brews - commands specified in Brewfile (e.g. tap 'homebrew/versions' \n brew 'wget' \n brew 'git')
cecho "Installing homebrew formulae..." $blue
cecho "Casks will be linked in /Applications" $cyan
brew tap homebrew/bundle
brew bundle --file=${STARTER}/osx/brew/Brewfile

# verify cask install
#brew cask doctor
#brew bundle Caskfile

# Cleanup
cecho "Remove outdated homebrew formulae from the cellar"
brew cleanup

# Switch to using brew-installed bash as default shell
if ! fgrep -q "$(brew --prefix bash)/bin/bash" /etc/shells; then
  echo "Switching default shell to bash";
  echo "$(brew --prefix bash)/bin/bash" | sudo tee -a /etc/shells;
  chsh -s "$(brew --prefix bash)/bin/bash";
fi;

# Remove the quarantine attribute
# xattr -r ~/Library/QuickLook
xattr -d -r com.apple.quarantine ~/Library/QuickLook

# install n and node@lts
curl -L https://git.io/n-install | N_PREFIX=$HOME/.bin/n /bin/bash -s -- -y lts
