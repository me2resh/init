#!/bin/bash

SCRIPT_DIR=$(cd `dirname $0` && pwd)

mkdir $HOME/vimswap

for i in `find $SCRIPT_DIR -maxdepth 1 -name '.*' | grep -v git`; do
    home_path=$HOME/`basename $i`
    if [ -f $home_path -o -L $home_path ]; then
        mv $home_path ${home_path}.old;
    fi;
    ln -sv $i $HOME
done

git config --global user.name "Ahmed Abdelaliem"
git config --global user.email "ahmed.abdelaliem@gmail.com"
git config --global color.ui auto
git config --global alias.st status

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

brew install the_silver_searcher


