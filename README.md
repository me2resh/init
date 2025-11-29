# init

Bootstrap dotfiles and development tooling for macOS or Debian/Ubuntu with a single command.

## What it does
This repo automates almost everything described in <a href="https://www.me2resh.com/posts/2020/05/04/my-terminal-setup-on-mac-os.html" target="_blank" rel="noopener noreferrer">My Terminal Setup on macOS</a>:
- Copies the dotfiles in this repo into `$HOME`, backing up any existing files.
- Installs package prerequisites (Xcode CLT/Homebrew on macOS, apt packages on Debian/Ubuntu).
- Installs CLI tools and desktop apps:
  - [The Silver Searcher (ag)](https://github.com/ggreer/the_silver_searcher)
  - [Git](https://git-scm.com/)
  - [tmux](https://github.com/tmux/tmux)
  - [zsh](https://www.zsh.org/) + [Oh My Zsh](https://ohmyz.sh/)
  - [wget](https://www.gnu.org/software/wget/)
  - [fzf](https://github.com/junegunn/fzf) with key bindings/completions
  - [jq](https://stedolan.github.io/jq/)
  - [Vim](https://www.vim.org/) and [Ultimate vimrc](https://github.com/amix/vimrc)
  - [Maximum Awesome](https://github.com/square/maximum-awesome) (macOS by default, optional via `INSTALL_MAXIMUM_AWESOME`)
  - [bash-completion](https://github.com/scop/bash-completion)
  - [Ruby](https://www.ruby-lang.org/)
  - [iTerm2](https://iterm2.com/) + bundled profile (macOS)
- Sets up zsh/Oh My Zsh with the pygmalion theme, Solus colors, and useful plugins.
- Configures fzf key bindings, git defaults, SSH keys, tmux plugins, and other editor tooling.

## Usage
```bash
git clone https://github.com/<your-user>/init.git ~/init
cd ~/init
bash init.sh            # INSTALL_MAXIMUM_AWESOME=false bash init.sh to skip Maximum Awesome on macOS
```
When the script finishes, open a new terminal (or `exec zsh`) so the new shell config takes effect.

### macOS-specific notes
- You’ll be prompted to install Xcode Command Line Tools and to allow Homebrew installs.
- iTerm2 is installed via cask (skipped if already present) and the bundled profile is placed under `~/Library/Application Support/iTerm2/DynamicProfiles` so you can select it under Preferences → Profiles.
- Maximum Awesome runs by default; rerun with `INSTALL_MAXIMUM_AWESOME=false bash init.sh` if you prefer to keep your existing vim/tmux configs.

### Ubuntu (Debian-based) notes
- The script runs `sudo apt-get update` and installs all dependencies listed in `ensure_linux_packages()`. You’ll be prompted for sudo once.
- Xcode/iTerm steps are skipped; otherwise the dotfile/zsh/fzf/git/Vim setup is the same.

## Safe dry run
```bash
mkdir -p /tmp/init-test
HOME=/tmp/init-test bash init.sh
```
Inspect `/tmp/init-test` to confirm the results without touching your real `$HOME`.

## Notes
- All plugins/themes are cloned into your home directory at install time; the repo no longer ships plugin code.
- `init.sh` only creates SSH keys, git config, or Homebrew when they don’t already exist.
- Detailed manual instructions live in `docs/setup.md` if you need to run individual steps by hand.
