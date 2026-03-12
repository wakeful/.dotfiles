function qq --description 'Switch kubectl context via fzf'
    set -l ctx (kubectl config get-contexts --no-headers -o name | fzf)
    test -n "$ctx" && kubectl config use-context $ctx
end
