#!/bin/bash

set -x
function config() {
  git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}

git clone --bare https://github.com/ccancinos/.dotfiles.git $HOME/.dotfiles
config checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
else
  echo "Backing up pre-existing dotfiles.";
  mkdir -p .dotfiles-backup
  config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} sh -c 'mkdir -p .dotfiles-backup/{}; mv {} .dotfiles-backup/{};'
fi;
config checkout
config config --local status.showUntrackedFiles no
chmod -R a+x ~/.config/bin/*.sh
source ~/.zshrc
