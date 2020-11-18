# Dotfiles

### Installing dotfiles on a new system

```
alias config='user/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'
echo ".cfg" >> .gitignore
git clone --bare git@github.com:bktim/dotfiles.git $HOME/.cfg
config checkout
config config --local status.showUntrackedFiles no
```



