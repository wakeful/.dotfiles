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
