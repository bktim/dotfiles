# Dotfiles

### Installing dotfiles on a new system

```
echo "alias config='/usr/bin/git --git-dir=$HOME/.cfg --work-tree=$HOME'" >> $HOME/.bashrc
source $HOME/.bashrc
echo ".cfg" >> .gitignore
git clone --bare git@github.com:bktim/dotfiles.git $HOME/.cfg
config checkout
config config --local status.showUntrackedFiles no
```



