export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""               # pure will drive the prompt
plugins=(git)
source "$ZSH/oh-my-zsh.sh"

# --- zplug + pure prompt ------------------------------------------------------
_detect_zplug_home() {
  if command -v brew >/dev/null 2>&1; then
    local brew_path="$(brew --prefix 2>/dev/null)/opt/zplug"
    [[ -d "$brew_path" ]] && { echo "$brew_path"; return; }
  fi
  [[ -d "$HOME/.zplug" ]] && echo "$HOME/.zplug"
}

ZPLUG_HOME="${ZPLUG_HOME:-$(_detect_zplug_home)}"
if [[ -n "$ZPLUG_HOME" && -f "$ZPLUG_HOME/init.zsh" ]]; then
  export ZPLUG_HOME
  source "$ZPLUG_HOME/init.zsh"
  zplug "mafredri/zsh-async", from:github
  zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
  zplug "sindresorhus/pure", use:async.zsh, from:github
  zplug "zsh-users/zsh-syntax-highlighting", as:plugin, defer:2
  zplug "zsh-users/zsh-autosuggestions", as:plugin, defer:2
  if ! zplug check --verbose >/dev/null 2>&1; then
    zplug install
  fi
  zplug load
fi

# --- Pure prompt customization (git + AWS line) -------------------------------
_pure_git_branch() {
  command git symbolic-ref --short HEAD 2>/dev/null
}

_pure_git_dirty() {
  command git diff --quiet --ignore-submodules HEAD 2>/dev/null || printf '+'
}

_pure_git_ahead() {
  local ahead
  ahead=$(command git rev-list --left-only --count @{upstream}...HEAD 2>/dev/null)
  [[ -n "$ahead" && "$ahead" -gt 0 ]] && printf '⇡'
}

_pure_git_behind() {
  local behind
  behind=$(command git rev-list --right-only --count @{upstream}...HEAD 2>/dev/null)
  [[ -n "$behind" && "$behind" -gt 0 ]] && printf '⇣'
}

_pure_aws_profile() {
  printf '%s' "${AWS_PROFILE:-${AWS_DEFAULT_PROFILE:-default}}"
}

pure_custom_status_line() {
  local dir="${PWD##*/}"
  local git_branch=$(_pure_git_branch)
  local git_dirty=$(_pure_git_dirty)
  local git_ahead=$(_pure_git_ahead)
  local git_behind=$(_pure_git_behind)
  local aws="$(_pure_aws_profile)"
  local git_segment=""
  if [[ -n "$git_branch" ]]; then
    git_segment="on  $git_branch"
    if [[ -n "$git_dirty$git_ahead$git_behind" ]]; then
      git_segment+=" [${git_dirty:- }${git_ahead}${git_behind}]"
    fi
  fi
  print -r -- "${dir}${git_segment:+ $git_segment} on ☁️  (${aws})"
}

prompt_pure_precmds+=(pure_custom_status_line)
pure_symbol='✦ ❯ '

# --- misc --------------------------------------------------------------------
export EDITOR=vim
