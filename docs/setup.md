# Manual setup reference

These are the individual commands and steps `init.sh` automates. Use them if you want to run pieces manually or troubleshoot.

## Xcode Command Line Tools (macOS)
```bash
xcode-select --install
```
Follow the GUI prompts to finish installation.

## iTerm2
- Download from https://iterm2.com and drag into `/Applications`.
- The script also copies `iterm/Default.json` into `~/Library/Application Support/iTerm2/DynamicProfiles`; select the "Default" profile inside iTerm after installation.

## Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Zsh & Oh My Zsh
```bash
brew install zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s "$(which zsh)"
source ~/.zshrc
```

## Zsh plugins and themes
```bash
brew install wget
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
wget -P "$ZSH_CUSTOM/themes" https://gist.githubusercontent.com/me2resh/248b703b1cc56bcace2a688ce7e3e71b/raw/d1fa30e1cfb35b5833f1650c01ecdc2e0b730c5b/solus.zsh-theme
```
Set in `~/.zshrc`:
```zsh
ZSH_THEME="pygmalion"
plugins=(git colored-man-pages colorize pip python brew macos zsh-syntax-highlighting zsh-autosuggestions virtualenv)
```

## fzf & jq
```bash
brew install fzf
$(brew --prefix)/opt/fzf/install --all --no-update-rc
brew install jq
```

## Git & GitHub
```bash
brew install git
git config --global user.name "Your Name Here"
git config --global user.email "your_email@example.com"
git config --global credential.helper osxkeychain
```

## SSH keys
```bash
ls -al ~/.ssh
ssh-keygen -t rsa -C "your_email@example.com"
eval "$(ssh-agent -s)"
cat <<'CONFIG' >> ~/.ssh/config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa
CONFIG
ssh-add -K ~/.ssh/id_rsa
pbcopy < ~/.ssh/id_rsa.pub
```

## Bash completion
```bash
brew install bash-completion
echo "[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion" >> ~/.bash_profile
source ~/.bash_profile
```

## Vim tooling
```bash
brew install vim
brew install git # if needed for cloning
git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
INSTALL_MAXIMUM_AWESOME=true bash init.sh   # or run the repo's rake instructions manually
```

## Additional CLI packages (Linux via apt)
```bash
sudo apt-get update
sudo apt-get install -y automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev tmux git bash-completion exuberant-ctags silversearcher-ag zsh wget vim fzf curl openssh-client ruby-full
```

This file mirrors the README’s previous detailed sections. When in doubt, run `bash init.sh` instead—it handles all of these steps idempotently.
