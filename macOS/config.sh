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
softwareupdate --install-rosetta

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
    "$HOME/workspace/github.com/AlanGreene"
    "$HOME/workspace/sublime-projects"
    "$HOME/Downloads/torrents/archive"
    "$HOME/Downloads/torrents/complete"
    "$HOME/Downloads/torrents/downloading"
  )

  for i in "${directories[@]}"; do
    mkdir -p "$i"
  done
fi

if test ! $(which n); then
  # install n and node@lts
  curl -L https://git.io/n-install | N_PREFIX=$HOME/.bin/n /bin/bash -s -- -n -y lts
fi

export N_PREFIX=$HOME/.bin/n
export PATH=$PATH:$N_PREFIX/bin

cecho "Installing local npm registry" $cyan
npm i -g verdaccio

# install any dependencies for JS scripts
cecho "Installing dependencies for ~/.bin/" $cyan
pushd .
cd $HOME/.bin
npm i
popd

cecho "Install kustomize" $cyan
go get sigs.k8s.io/kustomize/kustomize/v3
GO111MODULE=on go install sigs.k8s.io/kustomize/kustomize/v3

cecho "Cleaning up unused shell files" $cyan
rm -rf $HOME/.bash_sessions
rm -rf $HOME/.zsh_sessions
rm -f $HOME/.zsh_history

cecho "Enable shell completions provided by brew formulae" $cyan

cecho "Configuring macOS preferences" $cyan
source ${STARTER}/macOS/defaults.sh

cecho "Checking for modified files" $cyan
git diff-index --exit-code --name-only HEAD
