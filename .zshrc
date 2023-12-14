# Initialize FZF and default completions / keybindings.
# Important that we do this first, so we can overwrite
# keybindings below.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Add completions for Homebrew-installed tools
fpath+=("$(brew --prefix)/share/zsh/site-functions")

# init autocomplete
autoload -U compinit; compinit

# Shared persistent history, inspired by https://eli.thegreenplace.net/2013/06/11/keeping-persistent-history-in-bash
# ctrl+r uses a shared, persistent history that combines all commands run from any shell session.
# up/down/ctrl+p/ctrl+n is a per-shell history that never gets saved to disk.
#
# We roll our own because Zsh's built-in history functionality doesn't allow us
# to keep "global persistent history" and "per-shell history" separate.
#
# Disable Zsh's built in persistent history (we roll our own below).
# Per-shell history still works--it's just never saved to disk.
unset HISTFILE

# Function that we run before every prompt to save the last-run command to $PERSISTENT_HISTORY_FILE.
log_zsh_persistent_history() {
  local cmd=$(fc -ln -1) # Last command
  cmd=${cmd/^\s*/}       # Remove leading spaces
  if [ "$cmd" != "$PERSISTENT_HISTORY_LAST" ]; then # Avoid duplicate history entries when repeating commands
    echo "$cmd" >> "${PERSISTENT_HISTORY_FILE:-$HOME/.persistent_zsh_history}"
    export PERSISTENT_HISTORY_LAST="$cmd"
  fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd log_zsh_persistent_history # Run before every prompt

# FZF widget (based on the default ctrl-r implementation at /opt/homebrew/opt/fzf/shell/key-bindings.zsh)
# that reads from $PERSISTENT_HISTORY_FILE.
# Only considers the most recent 10000 history entries, and uses awk to remove duplicates.
persistent-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null

  local persistent_history_file="${PERSISTENT_HISTORY_FILE:-$HOME/.persistent_zsh_history}"
  selected=$(tail -n 10000 "$persistent_history_file" | awk '!seen[$0]++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} -n2..,.. --layout=reverse --tac --scheme=history --bind=ctrl-z:ignore ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} +m" $(__fzfcmd))
  
  local ret=$?
  if [ -n "$selected" ]; then
    LBUFFER="$selected"
    CURSOR=$#LBUFFER
  fi
  zle reset-prompt
  return $ret
}
zle     -N            persistent-history-widget
bindkey -M emacs '^R' persistent-history-widget
bindkey -M vicmd '^R' persistent-history-widget
bindkey -M viins '^R' persistent-history-widget

# Set up the visited-directory stack
setopt AUTO_PUSHD          # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS   # Do not store duplicates in the stack.
setopt PUSHD_SILENT        # Do not print the directory stack after pushd or popd.
alias d='dirs -v' # Show recently-visited dirs. -v indexes them
# Type "3" to jump to the 3rd directory on the stack
for index ({1..9}) alias "$index"="cd +${index}"; unset index

# Initialize the Pure prompt
autoload -U promptinit; promptinit
prompt pure

# Shell
alias l='ls -Gp'
alias la='ls -Gpa'
alias ll='ls -Gpl'
alias lal='ls -Gpal'

# git
# Git
alias ga='git add'
alias gs='git status'
alias gc='git commit --verbose'
alias gd='git difftool --no-symlinks --dir-diff'
alias gf='git fetch'
alias gr='git remote -v'
alias gb='git branch -v'
alias gm='git merge --no-ff'
alias gpl='git pull'
alias gps='git push'
alias gco='git checkout'
alias gl='git log --pretty=format:"%C(yellow) %h %C(red) %<(31,trunc)%cD %C(green) %<(25)%cN %C(black) %<(75,trunc)%s"'
alias glf='git log --name-status --pretty=format:"%C(yellow) %H %C(red) %cD %C(green) %<(25)%cN %C(black) %s"'

# Kitty term
# --all: Set for all tabs, not just the currently active one
# --configured: Set for new tabs / windows, too
# NB: This won't persist through a restart.
# alias kitty_darken='kitty @ set-colors --all --configured ~/.config/kitty/scheme_vibrantink.conf && kitty @ set-colors active_border_color=green'
# alias kitty_lighten='kitty @ set-colors --all --configured ~/.config/kitty/scheme_terminalbasic.conf && kitty @ set-colors active_border_color=black'

# Ripgrep
alias rgf="rg -F" # Treat pattern as fixed string instead of regex
