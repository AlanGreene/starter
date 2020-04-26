#!/bin/bash
set -Eeo pipefail

if [ "$SHELL" != "/bin/bash" ]; then
    echo "\$SHELL is currently $SHELL, switching to /bin/bash"
    chsh -s "/bin/bash"
    echo "Restart the terminal and run the script again"
    exit
fi

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

    echo -e "$color$message$reset"
}

# echo an error message before exiting
catch() {
  if [ "$1" != "0" ]; then
    cecho "\nCommand \"${last_command}\" failed with exit code $1.\nReview any logs above and retry.\n" $red
  fi
}
trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'catch $?' EXIT

###
# Here begins the good stuff
###

if [ ! -n "$STARTER" ]; then
    STARTER=~/.starter
fi

#if [ -d "$STARTER" ]; then
#    # TODO: need to support updates
#    cecho "You already have the dotfiles starter installed. Remove $STARTER if you want to install again." $red
#    exit
#fi

cecho "\nAbout to begin setup, enter your password when prompted\n" $yellow

# Ask for the administrator password upfront
# and run a keep-alive to update existing `sudo` time stamp until script has finished
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# set default platform
platformFileLoc="macOS"

case "$OSTYPE" in
    darwin*)
        cecho "Detected macOS, beginning setup" $cyan
        ;;
    linux*)
        cecho "This dotfile starter currently only supports macOS. Linux support coming soon. Exiting." $red
        exit 1
        ;;
    *)
        cecho "Unsupported: $OSTYPE" $red
        cecho "This dotfile starter currently only supports macOS. Exiting." $red
        exit 1
        ;;
esac

STARTLOC=`pwd`

if [ ! -d "$STARTER" ]; then
    cecho "Cloning dotfiles starter..." $cyan
    hash git >/dev/null 2>&1 && env git clone --depth=1 --recursive https://github.com/AlanGreene/starter.git $STARTER || {
        cecho "git not installed" $red
        exit
    }
else
    cecho "$STARTER already exists, press ENTER to continue, ^C to exit" $yellow
    read
    cecho "Checking status of $STARTER" $cyan
    cd $STARTER
    cecho "Checking for modified files" $cyan
    git diff-index --exit-code --name-only HEAD
    cecho "Updating $STARTER" $cyan
    git pull
    cecho "$STARTER updated" $green
fi

cd $STARTER

source ${platformFileLoc}/config.sh

cd $STARTLOC

cecho "\nDotfiles starter installation complete\n" $green
cecho "Restart to ensure configuration is properly applied\n" $yellow
