if status is-interactive
# Commands to run in interactive sessions can go here
end

set -g fish_greeting ""

set -g __fish_git_prompt_char_stateseparator ""
set -g __fish_git_prompt_color_branch cyan
set -g __fish_git_prompt_showdirtystate true
set -g __fish_git_prompt_char_dirtystate (set_color red)" x"(set_color normal)
set -g __fish_git_prompt_char_cleanstate (set_color green)" o"(set_color normal)

# set -g fish_command_time_min_seconds 1
# set -g fish_command_time_msg "Time: %s sec"
# set -g fish_command_time_color cyan
# source ~/.config/fish/functions/fish_postexec.fish

set -gx VAGRANT_DISABLE_STRICT_DEPENDENCY_ENFORCEMENT 1
set -gx DISABLE_TELEMETRY true
set -gx TF_PLUGIN_CACHE_DIR $HOME/.plugin-cache
set -gx GOPATH $HOME/go
set -gx EDITOR vim

fish_add_path $GOPATH/bin
fish_add_path $HOME/bin
fish_add_path $HOME/bin/zig
fish_add_path /opt/homebrew/bin
fish_add_path $HOME/bin/google-cloud-sdk/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/.local/bin
fish_add_path /sbin
fish_add_path /bin
fish_add_path /usr/sbin
fish_add_path /usr/bin
fish_add_path /usr/games
fish_add_path /usr/local/sbin
fish_add_path /usr/local/bin

alias c "clear"
alias mkdir "mkdir -p"
alias ssh-rebuild "cat ~/.ssh/conf.d/* > ~/.ssh/config"
alias tmux "tmux -2"

starship init fish | source
