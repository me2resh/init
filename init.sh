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



platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='mac'
fi

if [[ $platform == 'linux' ]]; then
    brew install the_silver_searcher
    brew install git && brew install bash-completion
elif [[ $platform == 'freebsd' ]]; then
    sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev
    git clone git@github.com:ggreer/the_silver_searcher.git
    ./the_silver_searcher/build.sh
    cd the_silver_searcher/ && sudo make install && cd ../
    sudo apt-get install git bash-completion
fi



git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

source ~/.bash_profile

