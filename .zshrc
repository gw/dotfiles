# Add completions for Homebrew-installed tools
fpath+=("$(brew --prefix)/share/zsh/site-functions")

# init autocomplete
autoload -U compinit; compinit
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
