function bb --description 'Fuzzy checkout git branch'
    set -l branches (git branch --all | grep -v HEAD | string trim)
    test -z "$branches" && return

    set -l branch (echo $branches | fzf-tmux -d (math 2 + (count $branches)) +m)
    test -z "$branch" && return

    git checkout (echo $branch | string trim | sed 's/.* //' | sed 's#remotes/[^/]*/##')
end
