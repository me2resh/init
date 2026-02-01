---
id: AgDR-0001
timestamp: 2026-02-01T21:42:00Z
agent: claude
model: claude-opus-4-5-20251101
trigger: user-prompt
status: executed
---

# Simplify tmux plugins to essentials only

> In the context of improving the init project's tmux configuration, facing plugin bloat with 11 plugins, I decided to reduce to 5 essential plugins (tpm, sensible, yank, resurrect, continuum) to achieve a leaner, more maintainable setup, accepting the loss of niche features rarely used in practice.

## Context

- Current tmux config had accumulated 11 plugins
- Many plugins (net-speed, fuzzback, copycat, better-mouse-mode) add complexity for features rarely used
- More plugins = more dependencies, slower startup, more things to break
- Native tmux mouse support (`set -g mouse on`) is sufficient for most use cases

## Options Considered

| Option | Pros | Cons |
|--------|------|------|
| Keep all 11 plugins | Maximum features, already configured | Bloat, slow startup, maintenance burden, rarely-used features |
| **Reduce to 5 essentials** | Lean, fast, maintainable, covers 90% of use cases | Lose fuzzy search, network stats, pattern matching |
| Native tmux only | Zero dependencies | Lose session persistence, clipboard integration |

## Decision

Chosen: **Reduce to 5 essentials**, because:
- tpm: Required for plugin management
- tmux-sensible: Universal defaults everyone needs
- tmux-yank: System clipboard integration - essential on macOS
- tmux-resurrect: Session persistence across restarts - essential
- tmux-continuum: Auto-saves resurrect - set and forget

**Removed plugins:**
- `tmux-better-mouse-mode`: Native `set -g mouse on` is sufficient
- `tmux-net-speed`: Rarely need network stats in status bar
- `tmux-fuzzback`: Cool but rarely used - how often do you fuzzy-search scrollback?
- `tmux-copycat`: Pattern search is nice but grep works
- `tmux-pain-control`: Only useful if you don't know pane bindings
- `tmux-mem-cpu-load`: Nice but Activity Monitor/htop when needed

## Consequences

- Faster tmux startup (fewer plugins to load)
- Less maintenance burden
- Simpler config to understand and debug
- Lose network stats in status bar (can use htop/btop when needed)
- Lose fuzzy scrollback search (use grep/less instead)
- Keep the features that matter: session persistence, clipboard, sane defaults

## Artifacts

- Linear: APE-216
- Files: `workspace/init/.tmux/.tmux.conf`
