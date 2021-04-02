# Enable simple aliases to be sudo'ed. ("sudone"?)
# http://www.gnu.org/software/bash/manual/bashref.html#Aliases says: "If the
# last character of the alias value is a space or tab character, then the next
# command word following the alias is also checked for alias expansion."
alias sudo='sudo '
alias _='sudo'

alias ll='ls -alh'
alias mkdir='mkdir -p'

# Shortcuts
alias w='cd ~/workspace'
alias t='w && cd tektoncd/dashboard'
# alias pd='w && cd some-docker-based-project && eval $(docker-machine env default)'
# alias e2e='cleanup webdriver; npm run e2e-bvt; cleanup webdriver'

alias hosts="sudo $EDITOR /etc/hosts"
alias aliases="$EDITOR ~/.bash_aliases"

alias flushdns="sudo killall -HUP mDNSResponder; sudo killall mDNSResponderHelper; sudo dscacheutil -flushcache"
alias timer='time cat'

# Proxy SSL on port 443 to the specified port
proxyssl() {
  sudo local-ssl-proxy --source 443 --target ${1:-8000}
}

# Checkout a PR by number
gitpr() {
  prNum=$1
  git fetch upstream pull/${prNum}/head:pr${prNum} && git checkout pr${prNum}
}

# Util
cleanup() {
  commandName=$1
  commandName="[${commandName:0:1}]${commandName:1}";
  getPid="kill -9 `ps ax | grep ${commandName} | awk '{print \$1}'`";
  echo ${getPid};
  eval ${getPid};
}

# NPM
# silent: completely silent. Zero logging output.
# win: Just the “npm ok” or “npm not ok” message at the end.
# error: When something unexpected and bad happens.
# warn: When something odd or potentially dangerous is happening.
# info: Helpful information so you can track what’s happening.
# verbose: Even more. Perhaps just a wee bit obnoxious, even.
# silly: Completely fuckin crazy, man. Dump everything. Whole objects, you name it, whatever.
#
# npm config set loglevel win
alias npms="npm --loglevel error"

# npm version 1.2.3
# edits package.json && git add package.json && git commit && git tag v1.2.3

# npm rebuild

# Browsers
alias safari="open -a safari"
alias firefox="open -a firefox"
alias opera="open -a opera"
alias chrome="open -a google\ chrome"
alias chrome_no_cors="open -n -a Google\ Chrome --args --user-data-dir=/tmp/temp_chrome_user_data_dir --disable-web-security about:blank"
#alias chromium="open -a chromium"

# IP addresses
alias publicip="dig +short myip.opendns.com @resolver1.opendns.com"
#alias ip="curl -s http://checkip.dyndns.com/ | sed 's/[^0-9\.]//g'"
alias ip=getIP
alias ips="ifconfig -a | grep -o 'inet6\? \(\([0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+\)\|[a-fA-F0-9:]\+\)' | sed -e 's/inet6* //'"
# ifconfig greps
alias ip4="ifconfig |grep 'inet '"
alias ip6="ifconfig |grep 'inet6 '"
alias ipall="ifconfig |grep inet"

#ifconfig | grep "inet " | awk '{ print $2 }' | cut -d ":" -f 2

function getIP() {
  for interface in en0 en1 en2; do
    echo $interface: `ipconfig getifaddr $interface`
  done
}

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# Show/hide hidden files in Finder
alias show="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
alias hide="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# One of @janmoesen’s ProTip™s
for method in GET HEAD POST PUT DELETE TRACE OPTIONS; do
  alias "$method"="lwp-request -m '$method'"
done

# Dev
#alias server="open http://localhost:8000 && python -m SimpleHTTPServer"
#alias server="curl lama.sh | sh"
server() {
  port=${1-8000}
  sleep 5 && open "http://localhost:${port}" &
  #python -m SimpleHTTPServer $port
  # updated for python 3
  python -m http.server $port
}

# Create a data URL from a file
function dataurl() {
    local mimeType=$(file -b --mime-type "$1")
    if [[ $mimeType == text/* ]]; then
        mimeType="${mimeType};charset=utf-8"
    fi
    echo "data:${mimeType};base64,$(openssl base64 -in "$1" | tr -d '\n')"
}

# Create a new directory and enter it
function mkd() {
  mkdir -p "$@" && cd "$@"
  # mkdir -p "$@" && cd "$_";
}

# Change working directory to the top-most Finder window location
function cdf() { # short for `cdfinder`
  cd "$(osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)')";
}

# Run `dig` and display the most useful info
function digga() {
  dig +nocmd "$1" any +multiline +noall +answer;
}

# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# Faster npm for Europeans (TODO: test this)
#command -v npm > /dev/null && alias npme="npm --registry http://registry.npmjs.eu/"

function volume() {
  local PCT
  PCT=$1
  osascript -e 'set volume output volume "'$PCT'"'
}

# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"

# Addy Osmani
# Launch installed browsers for a specific URL
# Usage: browsers "http://www.google.com"
function browsers(){
  chrome $1
  opera $1
  firefox $1
  safari $1
}

# git stats (lines changed, etc.)
#
# git diff --stat
# git diff --numstat
# git diff --shortstat

alias gitshort="git rev-list --all --abbrev=0 --abbrev-commit | awk '{ a[length] += 1 } END { for (len in a) print len, a[len] }'"

# simple git log
# usage glr v0.2.2 v0.2.3
function glr() {
  git log $1 $2 --pretty=format:'* %h %s' --date=short --no-merges
}

## git log with per-commit cmd-clickable GitHub URLs (iTerm)
#function gf() {
#  local remote="$(git remote -v | awk '/^origin.*\(push\)$/ {print $2}')"
#  [[ "$remote" ]] || return
#  local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
#  git log $* --name-status --color | awk "$(cat <<AWK
#    /^.*commit [0-9a-f]{40}/ {sha=substr(\$2,1,7)}
#    /^[MA]\t/ {printf "%s\thttps://github.com/$user_repo/blob/%s/%s\n", \$1, sha, \$2; next}
#    /.*/ {print \$0}
#AWK
#  )" | less -F
#}

# GitHub URL for current repo.
function gurl() {
  local remotename="${@:-origin}"
  local remote="$(git remote -v | awk '/^'"$remotename"'.*\(push\)$/ {print $2}')"
  [[ "$remote" ]] || return
  local user_repo="$(echo "$remote" | perl -pe 's/.*://;s/\.git$//')"
  echo "https://github.com/$user_repo"
}

function gpath() {
  local pathFromGitRoot="$(git rev-parse --show-prefix)"
  echo "$pathFromGitRoot"
}

alias timeline="git log --oneline --graph --decorate"
alias contributors="git --no-pager shortlog -s -n"

#alias branches-stale="git fetch origin --prune --dry-run"
#alias branches-prune="git fetch origin --prune"
alias branches-stale="git remote prune --dry-run origin"
alias branches-prune="git remote prune origin"

alias timestamp="date +%Y%m%d%H%M%S"

alias k="kubectl"
alias ka="kubectl apply -f"
alias kc="kubectx"
alias kg="kubectl get"
alias kl="kubectl logs"
alias klf="kubectl logs -f"
alias kn="kubens"
alias krm="kubectl delete"
alias kx="kubectl exec -i -t"

complete -F __start_kubectl k
# complete -F _kube_contexts kc
# complete -F _kube_namespaces kn
# what's the difference between these and the ones above?
complete -F _complete_alias kc
complete -F _complete_alias kn
complete -F _complete_alias kg
complete -F _complete_alias kl
complete -F _complete_alias klf
complete -F _complete_alias krm
complete -F _complete_alias kx

function kubeconfig() {
  if [ -n "$1" ]; then
    kubeConfigFile=$1
    touch -a $kubeConfigFile
  else
    kubeConfigFile=$KUBECONFIG_ORIGINAL
  fi
  export KUBECONFIG=$kubeConfigFile && kubeon
}
export -f kubeconfig

# Heroku
# PSQL UI
# heroku config:get DATABASE_URL | xargs pgweb --url

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec ${SHELL} -l"

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

## npm: list globally-installed packages
alias nlg="npm list -g --depth=0"

# Show all the names (CNs and SANs) listed in the SSL certificate
# for a given domain
function getcertnames() {
  if [ -z "${1}" ]; then
    echo "ERROR: No domain specified.";
    return 1;
  fi;

  local domain="${1}";
  echo "Testing ${domain}…";
  echo ""; # newline

  local tmp=$(echo -e "GET / HTTP/1.0\nEOT" \
    | openssl s_client -connect "${domain}:443" -servername "${domain}" 2>&1);

  if [[ "${tmp}" = *"-----BEGIN CERTIFICATE-----"* ]]; then
    local certText=$(echo "${tmp}" \
      | openssl x509 -text -certopt "no_aux, no_header, no_issuer, no_pubkey, \
      no_serial, no_sigdump, no_signame, no_validity, no_version");
    echo "Common Name:";
    echo ""; # newline
    echo "${certText}" | grep "Subject:" | sed -e "s/^.*CN=//" | sed -e "s/\/emailAddress=.*//";
    echo ""; # newline
    echo "Subject Alternative Name(s):";
    echo ""; # newline
    echo "${certText}" | grep -A 1 "Subject Alternative Name:" \
      | sed -e "2s/DNS://g" -e "s/ //g" | tr "," "\n" | tail -n +2;
    return 0;
  else
    echo "ERROR: Certificate not found.";
    return 1;
  fi;
}

alias fingerprint="ssh-keygen -l -E md5 -f $1"
