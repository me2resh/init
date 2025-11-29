# init

Bootstrap dotfiles and development tooling for macOS or Debian/Ubuntu with a single command.

## What it does
- Copies the dotfiles in this repo into `$HOME`, backing up any existing files.
- Installs package prerequisites (Xcode CLT/Homebrew on macOS, apt packages on Debian/Ubuntu).
- Installs CLI tools (ag, git, tmux, zsh, wget, fzf, vim, ruby, bash-completion) and desktop tooling (iTerm2 + bundled profile on macOS).
- Sets up zsh/Oh My Zsh with the pygmalion theme, Solus colors, and useful plugins.
- Installs fzf key bindings, configures global git + SSH keys, and bootstraps Vim/tmux plugins (Ultimate vimrc everywhere, Maximum Awesome by default on macOS).

## Usage
```bash
git clone https://github.com/<your-user>/init.git ~/init
cd ~/init
bash init.sh            # INSTALL_MAXIMUM_AWESOME=false bash init.sh to skip Maximum Awesome on macOS
```
When the script finishes, open a new terminal (or `exec zsh`) so the new shell config takes effect.

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
