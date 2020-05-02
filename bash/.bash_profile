# disable macos warning about zsh default shell
export BASH_SILENCE_DEPRECATION_WARNING=1

export EDITOR=nano

# Increase Bash history size. Default is 500.
export HISTSIZE='32768'
export HISTFILESIZE="${HISTSIZE}"
# Omit duplicates and commands that begin with a space from history, alt. 'ignorespace'
export HISTCONTROL='ignoreboth'

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

for f in $HOME/.{bash_secrets,bash_aliases,bash_prompt,bash_complete_alias}; do
  [ -f "$f" ] && source "$f";
done;
unset f;

export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && source "/usr/local/etc/profile.d/bash_completion.sh"

if [ -d $HOME/.bash_completion.d/ ]; then
  for f in $HOME/.bash_completion.d/*; do
    source $f
  done
  unset f
fi

eval "$(thefuck --alias)"
