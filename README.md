# Dotfiles

## Setup

### Configuring Git
- [ctags management](http://tbaggery.com/2011/08/08/effortless-ctags-with-git.html)
- Symlink `.git_template` to `~/.config`
- Configure git to use that folder with `git config --global init.templatedir '~/.config/.git_template'`
- For existing repos, remove `.git/hooks` and re-run `git init` to load the new hooks

### Custom fonts
Iosevka: Build from source using `private-build-plans.toml`
