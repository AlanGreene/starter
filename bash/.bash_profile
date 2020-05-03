# disable macos warning about zsh default shell
export BASH_SILENCE_DEPRECATION_WARNING=1

export EDITOR=nano

# Increase Bash history size. Default is 500.
export HISTSIZE='32768'
export HISTFILESIZE="${HISTSIZE}"
# Omit duplicates and commands that begin with a space from history, alt. 'ignorespace'
export HISTCONTROL='ignoreboth'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

export GOPATH=$HOME/workspace/go

export PATH="$HOME/.bin:$PATH"
export PATH=$PATH:$GOPATH/bin
#export PATH=$PATH:$HOME/workspace/public/kui/bin
#export PATH="/usr/local/opt/python/libexec/bin:$PATH"
#export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
#export PATH="$(brew --prefix ruby)/bin:$PATH"
#export PATH="$(gem environment gemdir)/bin:$PATH"
#export PATH=$PATH:$HOME/workspace/openshift/crc:$HOME/.crc/bin

export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
export PATH=$(brew --prefix findutils)/libexec/gnubin:$PATH
export PATH=$(brew --prefix curl)/bin:$PATH
export PATH=$(brew --prefix rsync)/bin:$PATH
export PATH=$(brew --prefix ssh-copy-id)/bin:$PATH

export KO_DOCKER_REPO='ko.local'

include () {
  [ -r "$1" ] && source "$1"
}

for f in $HOME/.{bash_secrets,bash_complete_alias,bash_aliases,bash_prompt}; do
  include "$f";
done;
unset f;

export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
include "$(brew --prefix)/etc/profile.d/bash_completion.sh"

if [ -d $HOME/.bash_completion.d/ ]; then
  for f in $HOME/.bash_completion.d/*; do
    source $f
  done
  unset f
fi

include "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.bash.inc"
include "$(brew --prefix)/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.bash.inc"

eval "$(thefuck --alias)"

shopt_options=(
  autocd
  checkwinsize
  cmdhist
  complete_fullquote
  dotglob
  expand_aliases
  extglob
  extquote
  force_fignore
  globasciiranges
  globstar
  histappend
  interactive_comments
  no_empty_cmd_completion
  nocaseglob
  progcomp
  promptvars
  sourcepath
)

for option in ${shopt_options[@]}; do
  shopt -s $option 2> /dev/null
done
