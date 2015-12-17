# Path to your oh-my-zsh installation.
export ZSH=/home/adrian/.oh-my-zsh

ZSH_THEME="ys"

plugins=(git terraform)

export PATH="/home/adrian/bin:/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin:/home/adrian/gopro/bin:/home/adrian/tools/terraform/:/home/adrian/tools/packer/"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

export LANG=en_US.UTF-8

export EDITOR='vim'
