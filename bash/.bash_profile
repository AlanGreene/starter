# disable macos warning about shell default switch to zsh
export BASH_SILENCE_DEPRECATION_WARNING=1

export EDITOR=nano

# Increase Bash history size. Default is 500.
export HISTSIZE='32768'
export HISTFILESIZE="${HISTSIZE}"
# Omit duplicates and commands that begin with a space from history.
export HISTCONTROL='ignoreboth'
# export HISTCONTROL=ignorespace

export GOPATH=$HOME/workspace/go

export PATH="$HOME/bin:$PATH"
export PATH=$PATH:$GOPATH/bin
#export PATH=$PATH:$HOME/workspace/public/kui/bin
#export PATH="/usr/local/opt/python/libexec/bin:$PATH"
#export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
#export PATH="$(brew --prefix ruby)/bin:$PATH"
#export PATH="$(gem environment gemdir)/bin:$PATH"
#export PATH=$PATH:$HOME/workspace/openshift/crc:$HOME/.crc/bin

export KO_DOCKER_REPO='ko.local'

if [ -f $HOME/.bash_secrets ]; then
  . $HOME/.bash_secrets
fi

if [ -f $HOME/.bash_aliases ]; then
  . $HOME/.bash_aliases
fi

if [ -f $HOME/.bash_prompt ]; then
  . $HOME/.bash_prompt
fi

if [ -f $HOME/.bash_complete_alias ]; then
  . $HOME/.bash_complete_alias
fi

export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

if [ -d $HOME/.bash_completion.d/ ]; then
  for f in $HOME/.bash_completion.d/*; do
    . $f
  done
fi

eval "$(thefuck --alias)"
