#!/bin/bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)

platform='unknown'
unamestr=$(uname -s)
if [[ "$unamestr" == 'Linux' ]]; then
    platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
    platform='mac'
fi

if [[ $platform == 'mac' ]]; then
    export NONINTERACTIVE=1
fi

info() {
    printf '[init] %s\n' "$*"
}

warn() {
    printf '[init][warn] %s\n' "$*"
}

run_with_sudo() {
    if command -v sudo >/dev/null 2>&1; then
        sudo "$@"
    else
        "$@"
    fi
}

ensure_shell_registered() {
    local shell_path="$1"
    if [ -z "$shell_path" ] || [ ! -x "$shell_path" ]; then
        return
    fi
    if ! grep -qx "$shell_path" /etc/shells 2>/dev/null; then
        info "Adding $shell_path to /etc/shells"
        run_with_sudo sh -c "echo '$shell_path' >> /etc/shells"
    fi
}

clone_or_update() {
    local repo_url="$1"
    local target_dir="$2"
    if [ -d "$target_dir/.git" ]; then
        git -C "$target_dir" pull --ff-only
    else
        git clone "$repo_url" "$target_dir"
    fi
}

deploy_dotfiles() {
    info "Copying dotfiles into HOME..."
    mkdir -p "$HOME/vimswap"
    while IFS= read -r -d '' file; do
        local target="$HOME/$(basename "$file")"
        if [ -e "$target" ] || [ -L "$target" ]; then
            local backup="${target}.old.$(date +%s)"
            mv "$target" "$backup"
            info "Backed up $target to $backup"
        fi
        if [ -d "$file" ]; then
            cp -a "$file" "$target"
        else
            cp -a "$file" "$target"
        fi
        info "Copied $(basename "$file") to $target"
    done < <(find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -name '.*' -not -name '.git' -print0)
}

ensure_xcode_clt() {
    if [[ $platform != 'mac' ]]; then
        return
    fi
    if xcode-select -p >/dev/null 2>&1; then
        info "Xcode Command Line Tools already installed."
    else
        info "Installing Xcode Command Line Tools..."
        xcode-select --install || true
        warn "Complete the GUI prompts to finish installing the command line tools."
    fi
}

ensure_homebrew() {
    if [[ $platform != 'mac' ]]; then
        return
    fi
    if ! command -v brew >/dev/null 2>&1; then
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    else
        info "Homebrew already installed."
    fi
    brew update
}

brew_has_formula() {
    local formula="$1"
    brew list --formula -1 | grep -qx "$formula" >/dev/null 2>&1
}

brew_has_cask() {
    local cask="$1"
    brew list --cask -1 | grep -qx "$cask" >/dev/null 2>&1
}

ensure_brew_formula() {
    local formula="$1"
    if ! brew_has_formula "$formula"; then
        info "Installing brew formula: $formula"
        brew install "$formula"
    else
        info "brew formula $formula already installed."
    fi
}

ensure_brew_cask() {
    local cask="$1"
    if brew_has_cask "$cask"; then
        info "brew cask $cask already installed."
        return
    fi
    if [[ "$cask" == 'iterm2' ]] && [ -d "/Applications/iTerm.app" ]; then
        info "iTerm already present in /Applications, skipping brew cask install."
        return
    fi
    info "Installing brew cask: $cask"
    brew install --cask "$cask"
}

install_iterm_profile() {
    if [[ $platform != 'mac' ]]; then
        return
    fi
    local profile_src="$SCRIPT_DIR/iterm/Default.json"
    if [ ! -f "$profile_src" ]; then
        warn "iTerm profile not found at $profile_src; skipping import."
        return
    fi
    local profile_dir="$HOME/Library/Application Support/iTerm2/DynamicProfiles"
    mkdir -p "$profile_dir"
    local profile_dest="$profile_dir/init-default-profile.json"
    PROFILE_SRC="$profile_src" PROFILE_DEST="$profile_dest" python3 - <<'PY'
import json, os, pathlib, sys
src = pathlib.Path(os.environ['PROFILE_SRC'])
dest = pathlib.Path(os.environ['PROFILE_DEST'])
with src.open() as f:
    data = json.load(f)
if 'Profiles' not in data:
    data = {'Profiles': [data]}
dest.write_text(json.dumps(data, indent=2))
PY
    info "Installed iTerm dynamic profile at $profile_dest. Select 'Default' inside iTerm to apply it."
    info "For the minimalist setup, set Preferences → Appearance → Theme to 'Minimal' and import Snazzy:"
    info "  curl -Ls https://raw.githubusercontent.com/sindresorhus/iterm2-snazzy/main/Snazzy.itermcolors > /tmp/Snazzy.itermcolors"
    info "  open /tmp/Snazzy.itermcolors"
}

ensure_linux_packages() {
    if [[ $platform != 'linux' ]]; then
        return
    fi
    local packages=(
        automake pkg-config libpcre3-dev zlib1g-dev liblzma-dev 
        tmux git bash-completion exuberant-ctags silversearcher-ag zsh wget vim fzf curl openssh-client ruby-full jq
    )
    info "Updating apt package index..."
    run_with_sudo apt-get update
    info "Installing apt packages: ${packages[*]}"
    run_with_sudo apt-get install -y "${packages[@]}"
}

install_macos_packages() {
    if [[ $platform != 'mac' ]]; then
        return
    fi
    ensure_homebrew
    ensure_brew_formula the_silver_searcher
    ensure_brew_formula git
    ensure_brew_formula bash-completion
    ensure_brew_formula coreutils
    ensure_brew_formula tmux
    ensure_brew_formula zsh
    ensure_brew_formula wget
    ensure_brew_formula fzf
    ensure_brew_formula vim
    ensure_brew_formula ruby
    ensure_brew_formula jq
    ensure_brew_formula zplug
    ensure_brew_cask iterm2
}

install_zplug_manager() {
    if [[ $platform == 'mac' ]]; then
        return
    fi
    local zplug_dir="$HOME/.zplug"
    if [ -d "$zplug_dir/.git" ]; then
        git -C "$zplug_dir" pull --ff-only
    elif [ ! -d "$zplug_dir" ]; then
        git clone https://github.com/zplug/zplug "$zplug_dir"
    fi
}

bootstrap_zplug_plugins() {
    if ! command -v zsh >/dev/null 2>&1; then
        return
    fi
    zsh -lc 'if type zplug >/dev/null 2>&1; then zplug check --verbose || zplug install; fi' || \
        warn "Unable to initialize zplug plugins automatically"
}

install_zsh_stack() {
    local zsh_path
    zsh_path=$(command -v zsh || true)
    if [ -n "$zsh_path" ] && [ "${SHELL:-}" != "$zsh_path" ]; then
        ensure_shell_registered "$zsh_path"
        info "Setting default shell to zsh..."
        chsh -s "$zsh_path" || warn "Failed to change default shell."
    fi

    local omz_dir="$HOME/.oh-my-zsh"
    if [ -d "$omz_dir/.git" ]; then
        info "Updating Oh My Zsh..."
        git -C "$omz_dir" pull --ff-only
    else
        info "Installing Oh My Zsh..."
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$omz_dir"
    fi

    install_zplug_manager
    bootstrap_zplug_plugins
}

install_fzf_tools() {
    if [[ $platform == 'mac' ]] && command -v brew >/dev/null 2>&1; then
        ensure_brew_formula fzf
        "$(brew --prefix)/opt/fzf/install" --all --no-update-rc
    else
        local fzf_dir="$HOME/.fzf"
        if [ -d "$fzf_dir/.git" ]; then
            info "Updating fzf from source..."
            git -C "$fzf_dir" pull --ff-only
        else
            info "Cloning fzf..."
            git clone --depth 1 https://github.com/junegunn/fzf.git "$fzf_dir"
        fi
        "$fzf_dir/install" --all --no-update-rc
    fi
}

set_git_config() {
    local key="$1"
    local value="$2"
    local current
    current=$(git config --global --get "$key" 2>/dev/null || true)
    if [ -z "$current" ]; then
        git config --global "$key" "$value"
    else
        info "Keeping existing git config $key=$current"
    fi
}

configure_git() {
    set_git_config user.name "Ahmed Abdelaliem"
    set_git_config user.email "ahmed.abdelaliem@gmail.com"
    set_git_config color.ui auto
    set_git_config alias.st status
    if [[ $platform == 'mac' ]]; then
        set_git_config credential.helper osxkeychain
    fi
}

ensure_ssh_setup() {
    local ssh_dir="$HOME/.ssh"
    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"
    local key_path="$ssh_dir/id_rsa"
    local email
    email=$(git config --global user.email 2>/dev/null || echo "your_email@example.com")
    if [ ! -f "$key_path" ]; then
        info "Generating new SSH key for $email"
        ssh-keygen -t rsa -b 4096 -C "$email" -N '' -f "$key_path"
    else
        info "SSH key already exists at $key_path"
    fi

    local ssh_config="$ssh_dir/config"
    touch "$ssh_config"
    if [[ $platform == 'mac' ]]; then
        if ! grep -q 'UseKeychain yes' "$ssh_config" >/dev/null 2>&1; then
            cat <<'CONFIG' >> "$ssh_config"
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa
CONFIG
        fi
    else
        if ! grep -q 'AddKeysToAgent yes' "$ssh_config" >/dev/null 2>&1; then
            cat <<'CONFIG' >> "$ssh_config"
Host *
  AddKeysToAgent yes
  IdentityFile ~/.ssh/id_rsa
CONFIG
        fi
    fi

    eval "$(ssh-agent -s)" >/dev/null
    if [[ $platform == 'mac' ]]; then
        ssh-add -K "$key_path" || warn "Failed to add SSH key to keychain"
    else
        ssh-add "$key_path" || warn "Failed to add SSH key to agent"
    fi

    if command -v pbcopy >/dev/null 2>&1; then
        pbcopy < "${key_path}.pub"
        info "Copied SSH public key to clipboard. Add it to GitHub via the web UI."
    else
        info "SSH public key is available at ${key_path}.pub. Add it to GitHub manually."
    fi
}

install_vim_tooling() {
    mkdir -p "$HOME/.vim/bundle"
    clone_or_update https://github.com/preservim/nerdtree.git "$HOME/.vim/bundle/nerdtree"
    clone_or_update https://github.com/altercation/vim-colors-solarized.git "$HOME/.vim/bundle/vim-colors-solarized"
    clone_or_update https://github.com/preservim/tagbar.git "$HOME/.vim/bundle/tagbar"
    clone_or_update https://github.com/drmad/tmux-git.git "$HOME/.tmux-git"
    clone_or_update https://github.com/tmux-plugins/tpm.git "$HOME/.tmux/plugins/tpm"

    clone_or_update https://github.com/amix/vimrc.git "$HOME/.vim_runtime"
    if [ -f "$HOME/.vim_runtime/install_awesome_vimrc.sh" ]; then
        sh "$HOME/.vim_runtime/install_awesome_vimrc.sh"
    fi

    local solarized_src="$HOME/.vim/bundle/vim-colors-solarized/colors/solarized.vim"
    local solarized_dest="$HOME/.vim/colors/solarized.vim"
    if [ -f "$solarized_src" ]; then
        mkdir -p "$(dirname "$solarized_dest")"
        cp -a "$solarized_src" "$solarized_dest"
    fi

    local default_max="false"
    if [[ $platform == 'mac' ]]; then
        default_max="true"
    fi
    local install_max_awesome="${INSTALL_MAXIMUM_AWESOME:-$default_max}"
    if [[ $install_max_awesome == 'true' && $platform == 'mac' ]]; then
        local max_dir="$HOME/maximum-awesome"
        clone_or_update https://github.com/square/maximum-awesome.git "$max_dir"
        if command -v rake >/dev/null 2>&1; then
            (cd "$max_dir" && rake)
            info "Maximum Awesome installed. Ignore its Solarized reminder and follow the Snazzy instructions in the README."
        else
            warn "rake not found; skipping Maximum Awesome bootstrap"
        fi
    else
        info "Skipping Maximum Awesome install (INSTALL_MAXIMUM_AWESOME=$install_max_awesome, platform=$platform)"
    fi
}

install_macos_packages
install_iterm_profile
ensure_linux_packages

deploy_dotfiles
configure_git
ensure_xcode_clt
install_zsh_stack
install_fzf_tools
ensure_ssh_setup
install_vim_tooling

info "Bootstrap complete. Restart your shell (bash or zsh) to pick up the new configuration."
