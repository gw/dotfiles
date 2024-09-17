# FZF
#
# Initialize FZF and default completions / keybindings.
# Important that we do this first, so we can overwrite
# keybindings below.
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

FD_OPTIONS="--follow --exclude .git --exclude node_modules"
# Used when invoking `fzf` without piping anything to it
export FZF_DEFAULT_COMMAND="fd --type f --type l --strip-cwd-prefix --hidden $FD_OPTIONS"

# Used when pressing ctrl+t
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
# Preview first 100 lines of files
export FZF_CTRL_T_OPTS="--preview 'bat -n -r :100 --color=always {}'"
# Used when pressing alt+c
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"
# Enable pressing ctrl+k to delete everything after cursor
export FZF_DEFAULT_OPTS='--bind ctrl-k:kill-line'


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
# that reads from $PERSISTENT_HISTORY_FILE instead of `fc -rl`.
# Only considers the most recent 10000 history entries, and uses awk to remove duplicates.
persistent-history-widget() {
  local selected num
  setopt localoptions noglobsubst noposixbuiltins pipefail no_aliases 2> /dev/null

  local persistent_history_file="${PERSISTENT_HISTORY_FILE:-$HOME/.persistent_zsh_history}"
  selected=$(tail -r "$persistent_history_file" | head -n 10000 | awk '!seen[$0]++' |
    FZF_DEFAULT_OPTS="--height ${FZF_TMUX_HEIGHT:-40%} ${FZF_DEFAULT_OPTS-} -n2..,.. --layout=reverse --scheme=history --bind=ctrl-z:ignore ${FZF_CTRL_R_OPTS-} --query=${(qqq)LBUFFER} +m" $(__fzfcmd))

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

# Don't delete past `/` when pressing ctrl+w or alt+backspace
WORDCHARS=${WORDCHARS/\//}

# Initialize the Pure prompt
autoload -U promptinit; promptinit
prompt pure
# Prepend current date and time to each prompt
PROMPT='%{$fg[yellow]%}%D{%L:%M:%S} '$PROMPT

# Shell
alias cd='j' # zoxide
alias l='ls -Gpl'
alias la='ls -Gpal'
# Function to create a directory and cd into it
mcd() {
    mkdir -p "$1" && cd "$1"
}


bindkey '^[[3;3~' kill-word

#alias cat='bat'

# Vim
alias vim='nvim'
alias v='nvim'

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
alias gprom='git pull --rebase origin master'
alias gps='git push'
alias gco='git checkout'
alias grs='git reset --soft HEAD~1'
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

# Joshuto
# Enable pressing "Q" to exit Joshuto while changing to whatever directory
# you're looking at.
function joshuto() {
	ID="$$"
	mkdir -p /tmp/$USER
	OUTPUT_FILE="/tmp/$USER/joshuto-cwd-$ID"
	env joshuto --output-file "$OUTPUT_FILE" $@
	exit_code=$?

	case "$exit_code" in
		# regular exit
		0)
			;;
		# output contains current directory
		101)
			JOSHUTO_CWD=$(cat "$OUTPUT_FILE")
			cd "$JOSHUTO_CWD"
			;;
		# output selected files
		102)
			;;
		*)
			echo "Exit code: $exit_code"
			;;
	esac
}
alias f='joshuto'


# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd() {
    \builtin pwd -L
}

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd() {
    # shellcheck disable=SC2164
    \builtin cd -- "$@"
}

# =============================================================================
#
# Hook configuration for zoxide.
#

# Hook to add new entries to the database.
function __zoxide_hook() {
    # shellcheck disable=SC2312
    \command zoxide add -- "$(__zoxide_pwd)"
}

# Initialize hook.
# shellcheck disable=SC2154
if [[ ${precmd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]] && [[ ${chpwd_functions[(Ie)__zoxide_hook]:-} -eq 0 ]]; then
    chpwd_functions+=(__zoxide_hook)
fi

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

__zoxide_z_prefix='z#'

# Jump to a directory using only keywords.
function __zoxide_z() {
    # shellcheck disable=SC2199
    if [[ "$#" -eq 0 ]]; then
        __zoxide_cd ~
    elif [[ "$#" -eq 1 ]] && { [[ -d "$1" ]] || [[ "$1" = '-' ]] || [[ "$1" =~ ^[-+][0-9]$ ]]; }; then
        __zoxide_cd "$1"
    elif [[ "$@[-1]" == "${__zoxide_z_prefix}"?* ]]; then
        # shellcheck disable=SC2124
        \builtin local result="${@[-1]}"
        __zoxide_cd "${result:${#__zoxide_z_prefix}}"
    else
        \builtin local result
        # shellcheck disable=SC2312
        result="$(\command zoxide query --exclude "$(__zoxide_pwd)" -- "$@")" &&
            __zoxide_cd "${result}"
    fi
}

# Jump to a directory using interactive search.
function __zoxide_zi() {
    \builtin local result
    result="$(\command zoxide query --interactive -- "$@")" && __zoxide_cd "${result}"
}

# Completions.
if [[ -o zle ]]; then
    function __zoxide_z_complete() {
        # Only show completions when the cursor is at the end of the line.
        # shellcheck disable=SC2154
        [[ "${#words[@]}" -eq "${CURRENT}" ]] || return 0

        if [[ "${#words[@]}" -eq 2 ]]; then
            _files -/
        elif [[ "${words[-1]}" == '' ]] && [[ "${words[-2]}" != "${__zoxide_z_prefix}"?* ]]; then
            \builtin local result
            # shellcheck disable=SC2086,SC2312
            if result="$(\command zoxide query --exclude "$(__zoxide_pwd)" --interactive -- ${words[2,-1]})"; then
                result="${__zoxide_z_prefix}${result}"
                # shellcheck disable=SC2296
                compadd -Q "${(q-)result}"
            fi
            \builtin printf '\e[5n'
        fi
        return 0
    }

    \builtin bindkey '\e[0n' 'reset-prompt'
    [[ "${+functions[compdef]}" -ne 0 ]] && \compdef __zoxide_z_complete __zoxide_z
fi

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

\builtin alias j=__zoxide_z
\builtin alias ji=__zoxide_zi

# =============================================================================
#
# To initialize zoxide, add this to your configuration (usually ~/.zshrc):
#
# eval "$(zoxide init zsh)"

