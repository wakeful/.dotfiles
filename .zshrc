# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.oh-my-zsh-custom

ZSH_THEME="ys"

plugins=(aws docker docker-compose docker-machine dotenv git go kubectl packer terraform vagrant zsh-autosuggestions)

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$HOME/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin"
# export MANPATH="/usr/local/man:$MANPATH"
[ -f ~/.cargo/env ] && source ~/.cargo/env

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

export EDITOR='vim'

alias c="clear"
alias cd..="cd .."
alias df="df -Th"
alias mkdir="mkdir -p"
alias ssh="cat ~/.ssh/conf.d/* > ~/.ssh/config;ssh"
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

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
