alias c clear
alias cd.. cd ..
alias df df -h
alias h history 25
alias j jobs -l
alias la ls -aF
alias lf ls -FA
alias ll ls -lAF
alias l ls -alh
alias mkdir mkdir -p
alias s screen
alias sl screen -ls
alias sr screen -rd
alias ss sockstat -4

alias gclaa 'git clone ssh://laatu/\!*'

# A righteous umask
umask 22

setenv GOPATH $HOME/gopro
set path = ($HOME/bin /sbin /bin /usr/sbin /usr/bin /usr/games /usr/local/sbin /usr/local/bin $GOPATH/bin $HOME/tools/terraform/ $HOME/tools/packer/)

setenv	EDITOR vim
setenv	PAGER less
setenv	BLOCKSIZE K

if ($?prompt) then
	# An interactive shell -- set some stuff up
	set prompt = "%N@%m:%~ %# "
	set promptchars = "%#"

	set filec
	set history = 1000
	set savehist = (1000 merge)
	set autolist = ambiguous
	# Use history to aid expansion
	set autoexpand
	set autorehash
	set mail = (/var/mail/$USER)
	if ( $?tcsh ) then
		bindkey "^W" backward-delete-word
		bindkey -k up history-search-backward
		bindkey -k down history-search-forward
	endif
endif

if ($term == "xterm" || $term == "vt100" || $term == "vt102" || $term !~ "con*") then 
    # bind keypad keys for console, vt100, vt102, xterm
    bindkey "\e[1~" beginning-of-line
    bindkey "\e[7~" beginning-of-line
    bindkey "\e[2~" overwrite-mode
    bindkey "\e[3~" delete-char
    bindkey "\e[4~" end-of-line
    bindkey "\e[8~" end-of-line
endif

set hosts48k = `grep -i "^host" $HOME/.ssh/config | cut -d" " -f2`
complete ssh 'p/*/$hosts48k/' 
complete scp "c,*:/,F:/," "c,*:,F:$HOME," 'c/*@/$hosts48k/:/'

complete cd 'C/*/d/'
complete rmdir 'C/*/d/'
complete chgrp 'p/1/g/'
complete chown 'p/1/u/'

