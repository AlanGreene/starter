# disable macos warning about zsh default shell
export BASH_SILENCE_DEPRECATION_WARNING=1

export EDITOR=nano

# Increase Bash history size. Default is 500.
export HISTSIZE='32768'
export HISTFILESIZE="${HISTSIZE}"
# Omit duplicates and commands that begin with a space from history, alt. 'ignorespace'
export HISTCONTROL='ignoreboth'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

export LANG='en_IE.UTF-8'
export LC_ALL='en_IE.UTF-8'

export GOPATH=$HOME/workspace/go

export PATH="$HOME/.bin:$HOME/.bin.local:$PATH"
export PATH="$PATH:/opt/homebrew/bin"
eval "$(brew shellenv)"

export PATH="$PATH:$GOPATH/bin"
#export PATH="$PATH:$HOME/workspace/public/kui/bin"
#export PATH="/usr/local/opt/python/libexec/bin:$PATH"
#export PATH="/usr/local/opt/ruby/bin:/usr/local/lib/ruby/gems/2.6.0/bin:$PATH"
#export PATH="$(brew --prefix ruby)/bin:$PATH"
#export PATH="$(gem environment gemdir)/bin:$PATH"
#export PATH="$PATH:$HOME/workspace/openshift/crc:$HOME/.crc/bin"
export PATH=$(brew --prefix coreutils)/libexec/gnubin:$PATH
export PATH=$(brew --prefix findutils)/libexec/gnubin:$PATH
export PATH=$(brew --prefix curl)/bin:$PATH
export PATH=$(brew --prefix rsync)/bin:$PATH
export PATH=$(brew --prefix ssh-copy-id)/bin:$PATH
export PATH=$PATH:/usr/local/sbin
export PATH="${PATH}:${HOME}/.krew/bin"

export KO_DOCKER_REPO='kind.local'
export KIND_CLUSTER_NAME='tekton-dashboard'
export GOROOT=`go env GOROOT`

# enable docker buildx for use with colima
# mkdir -p ~/.docker/cli-plugins
# curl -SL https://github.com/docker/buildx/releases/download/v0.12.1/buildx-v0.12.1.darwin-arm64 -o ~/.docker/cli-plugins/docker-buildx
# chmod +x ~/.docker/cli-plugins/docker-buildx

export KUBECONFIG=$HOME/.kube/config
export KUBECONFIG_ORIGINAL=$KUBECONFIG

# https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"  # This loads nvm
[ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

include () {
  [ -r "$1" ] && source "$1"
}

files=(
  "$HOME/.bash_secrets"
  "$HOME/.bash_complete_alias"
  "$HOME/.bash_aliases"
  "$HOME/.bash_aliases.local"
  "$HOME/.bash_env.local"
  "$HOME/.bash_prompt"
)

for f in "${files[@]}"; do
  include "$f"
done
unset f

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
  cdable_vars
  cdspell
  checkwinsize
  cmdhist
  complete_fullquote
  dirspell
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

# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber

# Enable history expansion with space
# E.g. typing !!<space> will replace the !! with your last command
bind Space:magic-space

if [ "${SSH_TTY}" != "" ] && [ -z "$TMUX" ]; then
  tmux attach -t default || tmux new -s default
fi
