#!/bin/bash

# Mac Software Update
#softwareupdate -i -a

# Install Xcode command line tools, required by git and others
#
# the following command opens a software update UI for user interaction so we won't use that
#xcode-select --install

# check if Xcode command line tools are already installed
cecho "Checking for Xcode command line tools..." $blue
! $(xcode-select -p > /dev/null 2>&1) && {
    #instead we use this neat trick from https://github.com/timsutton/osx-vm-templates/blob/master/scripts/xcode-cli-tools.sh
    echo "Installing Xcode command line tools..."
    touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress;
    PROD=$(softwareupdate -l |
      grep "Command Line Tools" |
      head -n 1 | awk -F"*" '{print $2}' |
      sed -e 's/^ Label: //' |
      tr -d '\n')
    softwareupdate -i "$PROD" --verbose;
}

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
brew bundle --file=${STARTER}/macOS/brew/Brewfile

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
