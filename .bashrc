[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# __git_ps1
source /usr/local/etc/bash_completion.d/git-prompt.sh
# Git autocompletion
source /usr/local/etc/bash_completion.d/git-completion.bash

# Use neovim for git commit editing
export EDITOR='nvim'
export GIT_EDITOR="$EDITOR"

# Moar history
HISTSIZE=5000
HISTFILESIZE=10000
# Avoid duplicates
export HISTCONTROL=ignoreboth:erasedups
# When the shell exits, append to the history file instead of overwriting it
shopt -s histappend

# Bat (a `cat` clone with wings)
export BAT_THEME='GitHub'

# FZF
# Drop-down instead of full-screen
# https://github.com/junegunn/fzf/issues/379
export FZF_DEFAULT_OPTS='--height 40% --reverse --history=~/.fzf_history'
# Use the faster fd instead of find
export FZF_DEFAULT_COMMAND='fd --type file'
# Preview first 100 lines of files
export FZF_CTRL_T_OPTS="--preview 'head -100 {}'"
# Make Ctrl-T do the same thing as typing `fzf` at command line
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# List directories breadth-first
# https://github.com/junegunn/blsd
export FZF_ALT_C_COMMAND='blsd'
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -$LINES'"


# So Ctrl-s can scroll through Bash history
stty -ixoff
stty stop undef
stty start undef

# Grant's aliases
# Tmux
# -u tells tmux that our terminal supports utf-8, and to not send them as '_'
# -f tells tmux to look elsewhere for tmux.conf
alias tmux='tmux -u -f ~/.config/tmux/tmux.conf'
# Emacs
alias e='TERM=xterm-24bit /usr/local/Cellar/emacs/26.2/bin/emacs'
# Shell
alias cat='bat'
alias l='ls -Gp'
alias la='ls -Gpa'
alias ll='ls -Gpl'
alias lal='ls -Gpal'
# Kitty term
# --all: Set for all tabs, not just the currently active one
# --configured: Set for new tabs / windows, too
# NB: This won't persist through a restart.
alias kitty_darken='kitty @ set-colors --all --configured ~/.config/kitty/scheme_vibrantink.conf'
alias kitty_lighten='kitty @ set-colors --all --configured ~/.config/kitty/scheme_terminalbasic.conf'
# Git
alias gg='git grep'
alias ga='git add'
__git_complete ga _git_add  # Enables auto-complete for an alias. Def'd in git-completion.bash
alias gs='git status'
__git_complete gs _git_status
alias gc='git commit --verbose'
__git_complete gc _git_commit
alias gd='git diff'
__git_complete gd _git_diff
alias gf='git fetch'
__git_complete gf _git_fetch
alias gr='git remote -v'
alias gb='git branch -v'
__git_complete gb _git_branch
alias gm='git merge --no-ff'
__git_complete gm _git_merge
alias gpl='git pull'
__git_complete gpl _git_pull
alias gps='git push'
__git_complete gps _git_push
alias gco='git checkout'
__git_complete gco _git_checkout
alias gl='git log --pretty=format:"%C(yellow) %h %C(red) %<(31,trunc)%cD %C(green) %<(25)%cN %C(black) %<(75,trunc)%s"'
__git_complete gll _git_log
alias glf='git log --name-status --pretty=format:"%C(yellow) %H %C(red) %cD %C(green) %<(25)%cN %C(black) %s"'
__git_complete glf _git_log
# Github Desktop
alias gh='github'
# fuzzy-finding git add powered by fzf
alias gaf='git ls-files -m -o --exclude-standard | fzf -m --print0 | xargs -0 -o -t git add'
# Hexdump
alias hex='hexdump -C'
# Neovim
alias vim='nvim'
alias v='nvim'
# Dotfile Configuration
alias vim_conf='vim ~/.config/nvim/init.vim'
alias kitty_conf='vim ~/.config/kitty/kitty.conf'
# count all occurrences of a pattern with ag
# Uses ag instead of rg b/c the former supports multi-line patterns
function count_pattern {
  ag -c "$1" | awk -F ":" '{print $NF}' | paste -sd+ - | bc
}

# cd to pushd
# Writing it as a function lets `cd` with no args still
# take you to home directory
pushd()
{
  if [ $# -eq 0 ]; then
    DIR="${HOME}"
  else
    DIR="$1"
  fi

  builtin pushd "${DIR}" > /dev/null
}
alias cd='pushd'

green="\[\033[38;5;050m\]"
red="\[\033[1;31m\]"
gray="\[\033[38;5;063m\]"
cyan="\[\033[38;5;031m\]"
reset="\[\033[m\]"

prompt_command() {
  local status="$?"
  local status_color=""
  if [ $status != 0 ]; then
    status_color=$red
  else
    status_color=$green
  fi
  export PS1="${gray}[\u@\h] ${cyan}\w${reset}${gray}$(__git_ps1)\n${status_color}\A ▶${reset} "
}
export PROMPT_COMMAND=prompt_command
# After each command, append to the history file and re-read it
# This is necessary for bash history to be shared across existing
# sessions, which is dope, b/c you can run a command in one window
# and immediately have that be available in all other windows.
# Commented b/c it's sometimes surprising/scary to be running a test command
# repeatedly in one window and then have another command suddenly appear
# as the most recent command.
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a" # Only append, so new shells get stuff from existing shells
