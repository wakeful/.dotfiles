# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.oh-my-zsh-custom

ZSH_THEME="ys"

plugins=(docker-machine git terraform packer)

export GOPATH=$HOME/go
export PATH="$GOPATH/bin:$HOME/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin"
# export MANPATH="/usr/local/man:$MANPATH"

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
  line=$(vvbox|jq -r '.[]| .state  + " | " + .path + " | " + .base + " | " + .id'| sort -r | column -t | fzf) && dir=$(echo $line|cut -d '|' -f2|sed 's/^ *//;s/ *$//') && cd "$dir"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
