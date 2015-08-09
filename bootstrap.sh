#!/bin/bash

# Colours
# tput setab [1-7] # Set the background colour using ANSI escape
# tput setaf [1-7] # Set the foreground colour using ANSI escape
black=`tput setaf 0`
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
blue=`tput setaf 4`
magenta=`tput setaf 5`
cyan=`tput setaf 6`
white=`tput setaf 7`

# Resets the style
reset=`tput sgr0`

# tput bold    # Select bold mode
# tput dim     # Select dim (half-bright) mode
# tput smul    # Enable underline mode
# tput rmul    # Disable underline mode
# tput rev     # Turn on reverse video mode
# tput smso    # Enter standout (bold) mode
# tput rmso    # Exit standout mode

function cecho() {
    defaultMsg="No message passed"
    message=${1:-$defaultMsg}
    color=${2:-$black}

    echo "$color$message$reset"
}

set -e

if [ ! -n "$STARTER" ]; then
    STARTER=~/.starter
fi

if [ -d "$STARTER" ]; then
    # TODO: need to support updates
    cecho "You already have the dotfiles starter installed. Remove $STARTER if you want to install again." $red
    exit
fi

# Ask for the administrator password upfront
# and run a keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# set default platform
platformFile=".osx"

case "$OSTYPE" in
    darwin*)
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
              grep "\*.*Command Line" |
              head -n 1 | awk -F"*" '{print $2}' |
              sed -e 's/^ *//' |
              tr -d '\n')
            softwareupdate -i "$PROD" -v;
        }
        ;;
    linux*)
        cecho "This dotfile starter currently only supports OSX. Linux support coming soon. Exiting." $red
        exit 1
        ;;
    *)
        cecho "Unsupported: $OSTYPE" $red
        cecho "This dotfile starter currently only supports OSX. Exiting." $red
        exit 1
        ;;
esac

cecho "Cloning dotfiles starter..." $blue
hash git >/dev/null 2>&1 && env git clone --depth=1 https://github.com/AlanGreene/starter.git $STARTER || {
    cecho "git not installed" $red
    exit
}

STARTLOC=`pwd`
cd $STARTER

source $platformFile

cd $STARTLOC

cecho "'\nDotfiles starter installation complete\n" $green
