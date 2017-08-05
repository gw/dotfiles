# Set GOPATH
set -x GOPATH $HOME/Code/git/go

# Add go binaries dir to PATH
set -x PATH (go env GOPATH)/bin $PATH

# Add llvm tools directory to PATH
set -x PATH /usr/local/Cellar/llvm/4.0.1/bin $PATH

# Add versioned user scripts directory to PATH
set -x PATH ~/Code/git/dotfiles/grant_scripts $PATH
