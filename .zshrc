# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.oh-my-zsh-custom

ZSH_THEME="ys"

plugins=(git terraform packer)

export PATH="$HOME/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin"
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
