# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.oh-my-zsh-custom

ZSH_THEME="ys"

plugins=(aws dotenv git golang kubectl terraform vagrant command-time zsh-autosuggestions)

ZSH_DISABLE_COMPFIX="true"
DISABLE_AUTO_UPDATE=true
ZSH_COMMAND_TIME_MIN_SECONDS=1
ZSH_COMMAND_TIME_MSG="Time: %s sec"
ZSH_COMMAND_TIME_COLOR="cyan"

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

export TF_PLUGIN_CACHE_DIR=$HOME/.plugin-cache
export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$HOME/bin:$HOME/bin/zig:/opt/homebrew/bin:$HOME/.krew/bin:$HOME/bin/google-cloud-sdk/bin:$HOME/.cargo/bin:$HOME/.local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin"
# export MANPATH="/usr/local/man:$MANPATH"
[ -f ~/.cargo/env ] && source ~/.cargo/env

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

export EDITOR='vim'

alias c="clear"
alias cd..="cd .."
alias mkdir="mkdir -p"
alias ssh-rebuild="cat ~/.ssh/conf.d/* > ~/.ssh/config"
alias tmux="tmux -2"
alias vvbox="jq '[.machines|to_entries[]| {base: .value.extra_data.box.name, data_path: .value.local_data_path, id: .key, name: .value.name, path: .value.vagrantfile_path, state: .value.state}]' ~/.vagrant.d/data/machine-index/index"

vv() {
  local line
  local dir
  line=$(vvbox|jq -r '.[]| [.state, .path, .name, .base, .id]|join(" | ")'| sort -r | column -t | fzf) && dir=$(echo $line|cut -d '|' -f2|sed 's/^ *//;s/ *$//') && cd "$dir"
}

ql() {
  local container
  container=$(kubectl get pod --all-namespaces --no-headers | fzf) && $(echo $container |  awk '{print "kubectl logs -f --namespace " $1 " "  $2 }')
}

function minicert() {
  for i in $(ls -1 ~/certs); do
    cat ~/certs/$i | minikube ssh "sudo mkdir -p /etc/docker/certs.d/$i && sudo tee /etc/docker/certs.d/$i/ca.crt";
  done
}

vterm_printf(){
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ] ); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}


if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
    alias clear='vterm_printf "51;Evterm-clear-scrollback";tput clear'
fi

autoload -U add-zsh-hook
add-zsh-hook -Uz chpwd (){ print -Pn "\e]2;%m:%2~\a" }

vterm_prompt_end() {
    vterm_printf "51;A$(whoami)@$(hostname):$(pwd)";
}
setopt PROMPT_SUBST
PROMPT=$PROMPT'%{$(vterm_prompt_end)%}'

vterm_cmd() {
    local vterm_elisp
    vterm_elisp=""
    while [ $# -gt 0 ]; do
        vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
        shift
    done
    vterm_printf "51;E$vterm_elisp"
}

[ -f ~/bin/helm ] && source <(helm completion zsh | sed -E 's/\["(.+)"\]/\[\1\]/g')
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
autoload -U +X bashcompinit && bashcompinit
