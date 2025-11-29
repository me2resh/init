# Manual setup reference

These are the individual commands and steps `init.sh` automates. Use them if you want to run pieces manually or troubleshoot.

## Xcode Command Line Tools (macOS)
```bash
xcode-select --install
```
Follow the GUI prompts to finish installation.

## iTerm2
- Download from https://iterm2.com and drag into `/Applications`.
- Set Preferences → Appearance → Theme to **Minimal** for the clean chrome-less window.
- Import the Snazzy palette (the script just copies the dynamic profile; color presets still need to be imported):
  ```bash
  curl -Ls https://raw.githubusercontent.com/sindresorhus/iterm2-snazzy/main/Snazzy.itermcolors > /tmp/Snazzy.itermcolors
  open /tmp/Snazzy.itermcolors
  ```
- The script also copies `iterm/Default.json` into `~/Library/Application Support/iTerm2/DynamicProfiles`; select the "Default" profile inside iTerm after installation.
- If you see Maximum Awesome’s Solarized reminder at the end of the bootstrap, ignore it and keep the Minimal + Snazzy setup.

## Homebrew
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Zsh, Oh My Zsh, zplug, and the pure prompt
```bash
brew install zsh zplug  # on Linux without Homebrew: git clone https://github.com/zplug/zplug ~/.zplug
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s "$(which zsh)"
cat <<'EOF' > ~/.zshrc
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

detect_zplug_home() {
  if command -v brew >/dev/null 2>&1; then
    local p="$(brew --prefix 2>/dev/null)/opt/zplug"
    [ -d "$p" ] && { echo "$p"; return; }
  fi
  [ -d "$HOME/.zplug" ] && echo "$HOME/.zplug"
}

ZPLUG_HOME="${ZPLUG_HOME:-$(detect_zplug_home)}"
if [ -n "$ZPLUG_HOME" ] && [ -f "$ZPLUG_HOME/init.zsh" ]; then
  export ZPLUG_HOME
  source "$ZPLUG_HOME/init.zsh"
  zplug "mafredri/zsh-async", from:github
  zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
  zplug "sindresorhus/pure", use:async.zsh, from:github
  zplug "zsh-users/zsh-syntax-highlighting", as:plugin, defer:2
  zplug "zsh-users/zsh-autosuggestions", as:plugin, defer:2
  if ! zplug check --verbose; then
    zplug install
  fi
  zplug load
fi
EOF
source ~/.zshrc
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
