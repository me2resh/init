export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# zplug + pure prompt setup
detect_zplug_home() {
  if command -v brew >/dev/null 2>&1; then
    local brew_zplug="$(brew --prefix 2>/dev/null)/opt/zplug"
    if [ -d "$brew_zplug" ]; then
      echo "$brew_zplug"
      return
    fi
  fi
  if [ -d "$HOME/.zplug" ]; then
    echo "$HOME/.zplug"
  fi
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

# Convenience
export EDITOR=vim
