function kk --description 'Jump to a saved mark via fzf'
    set -q MARKPATH; or set -l MARKPATH $HOME/.marks
    set -l ndir (ls -1 $MARKPATH | fzf)
    test -n "$ndir" && cd (readlink $MARKPATH/$ndir)
end
