---
id: AgDR-0001
timestamp: 2026-02-01T21:42:00Z
agent: claude
model: claude-sonnet-4-5-20250929
trigger: user-prompt
status: executed
---

# Select tmux plugins for enhanced functionality

> In the context of improving the init project's tmux configuration, facing disabled mouse support and missing network monitoring, I decided to adopt tmux-better-mouse-mode, tmux-net-speed, tmux-fuzzback, tmux-continuum, and tmux-copycat plugins to achieve better user experience and productivity, accepting the dependency on external plugin maintenance.

## Context

- Current tmux config has mouse support explicitly disabled (`set -g mouse off`)
- No network bandwidth monitoring despite having CPU/memory stats
- Limited scrollback search capabilities
- Manual session persistence without auto-save
- Basic copy/paste without pattern matching for URLs, IPs, file paths

## Options Considered

| Option | Pros | Cons |
|--------|------|------|
| Native tmux only | No dependencies, always compatible | Limited features, verbose config, missing advanced functionality |
| TPM + curated plugins | Rich feature set, community maintained, modular | External dependencies, potential compatibility issues |
| Custom scripts | Full control, tailored to needs | High maintenance burden, reinventing wheel |

## Decision

Chosen: **TPM + curated plugins**, because:
- Leverages mature, well-tested solutions from tmux-plugins organization
- Modular approach allows enabling/disabling features easily
- Active community maintenance and updates
- TPM already integrated in current setup
- Plugins selected based on popularity, active maintenance, and specific needs

**Selected plugins:**
- `NHDaly/tmux-better-mouse-mode` - 1.3k stars, addresses scroll-without-pane-change usecase
- `tmux-plugins/tmux-net-speed` - Official plugin, simple network monitoring
- `roosta/tmux-fuzzback` - Fuzzy search integration for scrollback
- `tmux-plugins/tmux-continuum` - Auto-save companion to existing tmux-resurrect
- `tmux-plugins/tmux-copycat` - Predefined search patterns (URLs, IPs, files)
- `tmux-plugins/tmux-pain-control` - Consistent navigation keybindings

## Consequences

- Increased startup time due to plugin loading (minimal, <100ms)
- Dependency on plugin authors for updates and compatibility
- Need to document plugin installation for new users
- Better UX: mouse support, network stats, fuzzy search, auto-save
- Reduced manual config for common patterns

## Artifacts

- Linear: APE-216
- Files: `workspace/init/.tmux/.tmux.conf`
