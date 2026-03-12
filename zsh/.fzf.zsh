# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$HOME/.fzf/shell/key-bindings.zsh"

# ------------
alias fzf="fzf-tmux -d 7"
export FZF_DEFAULT_OPTS="--cycle --multi --reverse --inline-info --preview 'file --mime-type {} | sift -q text/plain && cat {} || echo blob' --preview-window right:60%:hidden --bind \?:toggle-preview --bind pgup:preview-page-up --bind pgdn:preview-page-down"

bb() {
  local branches branch
  branches=$(git branch --all | grep -v HEAD) &&
  branch=$(echo "$branches" |
           fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

alias git-tmp='FILES=$(git status --short | sed "s/^[ ]//g" | egrep "^[A-Z]" | cut -d " " -f2 | fzf) && echo $FILES | xargs -L1 -t git update-index --assume-unchanged'
alias git-undo-tmp='FILES=$(git ls-files -v | egrep "^[a-z]" | cut -d " " -f2 | fzf) && echo $FILES | xargs -L1 -t git update-index --no-assume-unchanged'
alias qq='k8s_context=$(kubectl config get-contexts --no-headers  -o name | fzf) && kubectl config use-context $k8s_context'

alias aws-select='PROFILE=$(cat ~/.aws/credentials ~/.aws/config | egrep "^\[" | sed -E -e "s/\[|\]|\[profile //g" | sort | uniq | fzf) && export AWS_PROFILE="$PROFILE"'

alias kk='ndir=$(ls -1 $MARKPATH | fzf) && cd $(readlink $MARKPATH/$ndir)'
alias jd='ndir=$(git status -s | rev | cut -d " " -f1 | rev | xargs -L1 dirname | sort | uniq | fzf) && cd $ndir'
alias jt='cd $(git rev-parse --show-toplevel)'
