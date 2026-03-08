function jd --description 'Jump to a git dirty file directory via fzf'
    set -l ndir (git status -s | awk '{print $NF}' | xargs -L1 dirname | sort -u | fzf)
    test -n "$ndir" && cd $ndir
end
