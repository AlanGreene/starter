#!/bin/bash
set -Eeo pipefail

# echo an error message before exiting
catch() {
  if [ "$1" != "0" ]; then
    cecho "\nCommand \"${last_command}\" failed with exit code $1.\nReview any logs above and retry.\n" $red
  fi
}
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'catch $?' EXIT

# Mac Software Update
#softwareupdate -i -a

# Install Xcode command line tools, required by git and others
#
# the following command opens a software update UI for user interaction so we won't use that
#xcode-select --install

# check if Xcode command line tools are already installed
cecho "Checking for Xcode command line tools..." $cyan
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
if test ! $(which brew); then
    cecho "Installing Homebrew..." $cyan
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
else
    cecho "Homebrew already installed." $green
fi

brew analytics off

# verify Homebrew install
cecho "Running brew doctor" $cyan
brew doctor || true
cecho "brew doctor complete\n" $cyan

# Update Homebrew
brew update
# Upgrade any existing formulae
brew upgrade

# install brews - commands specified in Brewfile (e.g. tap 'homebrew/versions' \n brew 'wget' \n brew 'git')
cecho "Installing homebrew formulae..." $cyan
cecho "Casks will be linked in /Applications" $cyan
brew tap homebrew/bundle
brew bundle --no-lock --file=${STARTER}/macOS/brew/Brewfile

# verify cask install
#brew cask doctor
#brew bundle Caskfile

# Cleanup
cecho "Remove outdated homebrew formulae from the cellar"
brew cleanup

# Switch to using brew-installed bash as default shell
if ! fgrep -q "$(brew --prefix bash)/bin/bash" /etc/shells; then
  echo "Adding brew-installed bash to allowed shells"
  echo "$(brew --prefix bash)/bin/bash" | sudo tee -a /etc/shells
fi

if [ "$SHELL" != "$(brew --prefix bash)/bin/bash" ]; then
  echo "Switching default shell to brew-installed bash"
  chsh -s "$(brew --prefix bash)/bin/bash"
fi

# Remove the quarantine attribute
# xattr -r ~/Library/QuickLook
xattr -d -r com.apple.quarantine ~/Library/QuickLook

if test ! $(which n); then
  # install n and node@lts
  curl -L https://git.io/n-install | N_PREFIX=$HOME/.bin/n /bin/bash -s -- -y lts
fi

cecho "Installing local npm registry" $cyan
npm i -g verdaccio

cecho "Stowing files to \$HOME" $cyan
cecho "Checking for modified files" $cyan
git diff-index --exit-code --name-only HEAD

# stow
# --target (-t): defaults to parent directory
# --verbose (-v)
# --simulate
# --delete (-D)
# --restow (-R): useful for pruning obsolete symlinks
common=(
  bash
  tmux
)

nonroot=(
  git
  node
  ssh
)

stowit() {
  cecho "Stowing $1" $cyan
  stow --adopt $1
  stow --restow $1
}

for package in ${common[@]}; do
  stowit $package
done

# install only user space folders
if [ "$(whoami)" != "root" ]; then
  for package in ${nonroot[@]}; do
    stowit $package
  done

  cecho "Creating additional directories" $cyan
  directories=(
    "$HOME/workspace/sublime-projects"
    "$HOME/Downloads/torrents/complete"
    "$HOME/Downloads/torrents/downloading"
  )

  for i in "${directories[@]}"; do
    mkdir -p "$i"
  done
fi

# install any dependencies for JS scripts
cecho "Installing dependencies for ~/.bin/" $cyan
pushd .
cd $HOME/.bin
npm i
popd

cecho "Checking for modified files" $cyan
git diff-index --exit-code --name-only HEAD
