# init

Bootstrap dotfiles and developer tooling for macOS or Debian/Ubuntu.

## Table of contents
1. [What init.sh automates](#what-initsh-automates)
2. [Usage](#usage)
3. [Base system details](#base-system-details)
   - [Xcode Command Line Tools (macOS)](#xcode-command-line-tools-macos)
   - [iTerm2](#iterm2)
   - [Homebrew](#homebrew)
   - [Zsh & Oh My Zsh](#zsh--oh-my-zsh)
   - [Zsh plugins and themes](#zsh-plugins-and-themes)
   - [fzf](#fzf)
   - [Git & GitHub](#git--github)
   - [SSH configuration](#ssh-configuration)
   - [Bash completion](#bash-completion)
   - [Vim tooling](#vim)
4. [Safe dry run](#safe-dry-run)
5. [Requirements](#requirements)
6. [Notes](#notes)
7. [Using the tooling](#using-the-tooling)

## What init.sh automates
Running `bash init.sh` now performs the entire macOS or Ubuntu bootstrap:
- Copies every dotfile in this repo into `$HOME`, backing up pre-existing files so your home config no longer symlinks back to the repo.
- Installs Xcode Command Line Tools (macOS) and prompts you to finish the GUI flow.
- Ensures package managers are ready: installs or updates Homebrew on macOS, runs `apt-get update` + package installs on Linux.
- Installs desktop tooling: Homebrew cask iTerm2 on macOS (skips if `/Applications/iTerm.app` already exists) and copies the repo’s `iterm/Default.json` profile into iTerm’s Dynamic Profiles folder.
- Installs CLI dependencies: ag, git, bash-completion, coreutils, tmux, zsh, wget, fzf, vim, ruby/rake, plus Linux equivalents via apt.
- Sets up Zsh, Oh My Zsh, and plugins (zsh-autosuggestions, zsh-syntax-highlighting) and switches the default shell to zsh.
- Downloads the Solus theme, configures `ZSH_THEME="pygmalion"`, and applies the plugin list.
- Installs fzf (brew or source) and enables key bindings + fuzzy completion.
- Configures global Git identity and `credential.helper osxkeychain` (macOS) if not already set.
- Generates an SSH key (if missing), configures `~/.ssh/config`, adds the key to the agent (and macOS keychain), and copies the public key to your clipboard when possible.
- Installs wget, bash completion, tmux plugins, Ultimate vimrc, and other editor tooling. Maximum Awesome installs by default on macOS (set `INSTALL_MAXIMUM_AWESOME=false` to skip).
- Reminds you to restart your shell when bootstrap completes.

## Usage
1. Clone the repo somewhere convenient:
   ```bash
   git clone https://github.com/<your-user>/init.git ~/init
   cd ~/init
   ```
2. Review `init.sh` to confirm the defaults match your preferences.
3. Run the script (you may be prompted for your sudo password and to finish GUI installers):
   ```bash
   bash init.sh
   ```
   To skip the Maximum Awesome vim/tmux stack on macOS, set `INSTALL_MAXIMUM_AWESOME=false bash init.sh`.
4. Restart your shell (or open a new terminal window) when the script finishes.

## Base system details
`init.sh` handles everything below automatically; the sections remain for reference and troubleshooting.

### Xcode Command Line Tools (macOS)
Install Apple’s CLI developer tools:
```bash
xcode-select --install
```
Follow the GUI prompts to finish installation.

### iTerm2
Download iTerm2 from [https://iterm2.com](https://iterm2.com). Drag the app into `/Applications`, then launch it via Launchpad. The script installs iTerm2 through Homebrew Cask if you prefer automation and copies `iterm/Default.json` into `~/Library/Application Support/iTerm2/DynamicProfiles`. Open iTerm → Settings → Profiles and select the “Default” dynamic profile to apply it.

### Homebrew
Install Homebrew if it isn’t already present:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
Homebrew installs missing CLI tools Apple doesn’t ship. The script installs/updates Homebrew automatically.

### Zsh & Oh My Zsh
Install zsh via Homebrew (macOS) so you have a modern shell:
```bash
brew install zsh
```
Install Oh My Zsh:
```bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
```
If the installer doesn’t change your login shell, do it manually:
```bash
chsh -s "$(which zsh)"
```
Apply config changes by reloading your shell:
```bash
source ~/.zshrc
```
The script performs all of these steps for you and even adds `/opt/homebrew/bin/zsh` to `/etc/shells` before calling `chsh` so macOS accepts the shell change.

### Zsh plugins and themes
Add plugins in `~/.zshrc`:
```zsh
plugins=(git colored-man-pages colorize pip python brew macos zsh-syntax-highlighting zsh-autosuggestions virtualenv)
```
Install the extra plugin repos:
```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
source ~/.zshrc
```
Install wget so you can fetch themes:
```bash
brew install wget
```
Download the Solus theme and set ZSH theme:
```bash
wget -P "$ZSH_CUSTOM/themes" https://gist.githubusercontent.com/me2resh/248b703b1cc56bcace2a688ce7e3e71b/raw/d1fa30e1cfb35b5833f1650c01ecdc2e0b730c5b/solus.zsh-theme
```
Update `.zshrc`:
```zsh
ZSH_THEME="pygmalion"
```
Reload zsh again after editing. All of these adjustments are automated in `init.sh`.

### fzf
Install fzf:
```bash
brew install fzf
$(brew --prefix)/opt/fzf/install
```
The install script enables key bindings (Ctrl-T/R, Alt-C) and fuzzy completion. `init.sh` runs the installation in non-interactive mode with `--all` so it never edits your rc files.

### Git & GitHub
Install Git (if not already):
```bash
brew install git
```
Configure your identity:
```bash
git config --global user.name "Your Name Here"
git config --global user.email "your_email@youremail.com"
git config --global credential.helper osxkeychain
```
`init.sh` sets these defaults only if they are missing.

### SSH configuration
Check for existing keys:
```bash
ls -al ~/.ssh
```
Generate a key if needed:
```bash
ssh-keygen -t rsa -C "your_email@example.com"
```
Add it to the agent and configure macOS keychain support:
```bash
eval "$(ssh-agent -s)"
cat <<'CONFIG' >> ~/.ssh/config
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa
CONFIG
ssh-add -K ~/.ssh/id_rsa
```
Copy the public key to your clipboard:
```bash
pbcopy < ~/.ssh/id_rsa.pub
```
The script automates key generation, config, agent add, and clipboard copy (when `pbcopy` exists).

### Bash completion
Install:
```bash
brew install bash-completion
```
Enable it by adding to `~/.bash_profile`:
```bash
echo "[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion" >> ~/.bash_profile
source ~/.bash_profile
```
The dotfiles in this repo already source Homebrew’s completion script.

### Vim
Install Vim:
```bash
brew install vim
```
Install the [Ultimate vimrc](https://github.com/amix/vimrc):
```bash
git clone https://github.com/amix/vimrc.git ~/.vim_runtime
sh ~/.vim_runtime/install_awesome_vimrc.sh
# or the basic version
sh ~/.vim_runtime/install_basic_vimrc.sh
```
Update later:
```bash
cd ~/.vim_runtime && git pull --rebase && cd -
```
Install [Maximum Awesome](https://github.com/square/maximum-awesome) if desired:
```bash
git clone https://github.com/square/maximum-awesome.git
cd maximum-awesome
rake
```
`init.sh` installs Ultimate vimrc everywhere. Maximum Awesome runs automatically on macOS unless you set `INSTALL_MAXIMUM_AWESOME=false`; Linux always skips it.

## Safe dry run
If you want to test `init.sh` without touching your current configuration, redirect `HOME` to a temporary directory:
```bash
mkdir -p /tmp/init-test
HOME=/tmp/init-test bash init.sh
```
Inspect `/tmp/init-test` to verify the results, then delete it when done.

## Requirements
- macOS with Homebrew installed (or allow the script to install it) or a Debian-based Linux distribution with sudo access.
- Git, curl, and bash (provided by default on both platforms).
- Internet access for cloning repositories and installing packages.

## Notes
- The script uses HTTPS for all git clones and retries existing checkouts with `git pull --ff-only`.
- `~/.fzf/install` (or Homebrew’s installer) is run with `--all --no-update-rc`, so no shell rc files are modified automatically.
- SSH key creation and agent configuration only happen if a key doesn’t already exist.

## Using the tooling
- **Zsh/Oh My Zsh**: open a new terminal (or run `exec zsh`) to load the pygmalion theme, autosuggestions, and syntax highlighting. Change themes by editing `ZSH_THEME` in `~/.zshrc` and rerunning `source ~/.zshrc`.
- **tmux**: start a session with `tmux` (or `tmux new -s <name>`). TPM installs live in `~/.tmux/plugins`; press `prefix` + `I` inside tmux to install/update plugins after editing `~/.tmux.conf`.
- **Vim**: launch `vim` (or `mvim` if Maximum Awesome/MacVim is installed). Plugins from Ultimate vimrc are under `~/.vim_runtime`. Disable Maximum Awesome on macOS with `INSTALL_MAXIMUM_AWESOME=false bash init.sh`.
- **Terminal themes**: iTerm’s dynamic profile from `iterm/Default.json` is copied automatically. Open iTerm’s Preferences → Profiles and select “Default” (or duplicate/edit it) to tweak fonts/colors as needed.
- **fzf**: press `Ctrl+T`, `Ctrl+R`, or `Alt+C` inside bash/zsh for fuzzy file search, history search, or directory jump. Customize behavior via `~/.fzf.bash` / `~/.fzf.zsh`.
- **fzf-backed git tools**: `ag` (the silver searcher) and `fzf` are available globally, so commands like `ag pattern` or `fzf --preview 'bat {}'` just work after install.
- **SSH/Git credentials**: your SSH key is stored in `~/.ssh/id_rsa` and already loaded into the agent; add it to GitHub via the clipboard content after the installer runs. Git is configured with your saved name/email unless you override them.
