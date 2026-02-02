# tmux Guide

This guide covers the tmux configuration installed by `init.sh`, which uses [Maximum Awesome](https://github.com/square/maximum-awesome) as a base with TPM plugins for enhanced functionality.

## Quick Start

```bash
# Start a new session
tmux

# Start a named session
tmux new -s myproject

# List sessions
tmux ls

# Attach to a session
tmux attach -t myproject

# Detach from session (inside tmux)
Ctrl+b d
```

---

## Understanding the Prefix Key

All tmux commands start with a **prefix key**. Our configuration uses:

| Prefix | Key |
|--------|-----|
| Default | `Ctrl+b` |

Press the prefix, release it, then press the command key.

**Example:** To split vertically, press `Ctrl+b`, release, then press `v`.

---

## Window Management

Windows are like tabs in a browser.

| Action | Keys |
|--------|------|
| Create new window | `Ctrl+b c` |
| Create named window | `Ctrl+b C` (then type name) |
| Next window | `Ctrl+b n` |
| Previous window | `Ctrl+b p` |
| Select window by number | `Ctrl+b 0-9` |
| List windows | `Ctrl+b w` |
| Rename current window | `Ctrl+b ,` |
| Kill current window | `Ctrl+b &` |
| Last active window | `Ctrl+b Ctrl+a` |

**Note:** Window numbering starts at 1 (not 0).

---

## Pane Management

Panes split a window into multiple terminals.

### Creating Panes

| Action | Keys |
|--------|------|
| Split horizontally (side by side) | `Ctrl+b v` or `Ctrl+b %` |
| Split vertically (top/bottom) | `Ctrl+b b` or `Ctrl+b "` |

New panes open in the same directory as the current pane.

### Navigating Panes (Vim-style)

| Action | Keys |
|--------|------|
| Move left | `Ctrl+b h` |
| Move down | `Ctrl+b j` |
| Move up | `Ctrl+b k` |
| Move right | `Ctrl+b l` |
| Cycle through panes | `Ctrl+b o` |
| Show pane numbers | `Ctrl+b q` |
| Go to pane by number | `Ctrl+b q` then `0-9` |

### Resizing Panes

| Action | Keys |
|--------|------|
| Resize in direction | `Ctrl+b` then hold arrow keys |
| Toggle zoom (fullscreen pane) | `Ctrl+b z` |
| Set main-horizontal layout | `Ctrl+b m` |

### Closing Panes

| Action | Keys |
|--------|------|
| Close current pane | `Ctrl+b x` or type `exit` |

---

## Mouse Support

Mouse support is **enabled by default**. You can:

- **Click** on a pane to focus it
- **Click** on a window in the status bar to switch
- **Drag** pane borders to resize
- **Scroll** with the mouse wheel (enters copy mode)
- **Click and drag** to select text

---

## Scrolling & Copy Mode

### Entering Scroll/Copy Mode

| Action | Keys |
|--------|------|
| Enter copy mode | `Ctrl+b [` |
| Scroll with mouse | Just scroll (auto-enters copy mode) |

### Navigating in Copy Mode (Vi keys)

| Action | Keys |
|--------|------|
| Move up | `k` or `Up` |
| Move down | `j` or `Down` |
| Move left | `h` or `Left` |
| Move right | `l` or `Right` |
| Page up | `Ctrl+b` |
| Page down | `Ctrl+f` |
| Half page up | `Ctrl+u` |
| Half page down | `Ctrl+d` |
| Go to top | `g` |
| Go to bottom | `G` |
| Search up | `?` then type search term |
| Search down | `/` then type search term |
| Next search result | `n` |
| Previous search result | `N` |
| Incremental search up | `Ctrl+r` |

### Copying Text

| Action | Keys |
|--------|------|
| Start selection | `Space` |
| Copy selection | `Enter` |
| Paste | `Ctrl+b ]` |
| Exit copy mode | `q` or `Escape` |

**With mouse:** Click and drag to select, then `Enter` to copy. The `tmux-yank` plugin copies to system clipboard automatically.

---

## Session Management

| Action | Keys |
|--------|------|
| Detach from session | `Ctrl+b d` |
| List sessions | `Ctrl+b s` |
| Rename session | `Ctrl+b $` |
| Switch to next session | `Ctrl+b )` |
| Switch to previous session | `Ctrl+b (` |

### From the terminal:

```bash
# Create new session
tmux new -s name

# List sessions
tmux ls

# Attach to session
tmux attach -t name
# or
tmux a -t name

# Kill a session
tmux kill-session -t name

# Kill all sessions
tmux kill-server
```

---

## Session Persistence (Resurrect & Continuum)

Our configuration includes plugins that **automatically save and restore sessions**.

### How it works:

- Sessions are **auto-saved every 15 minutes**
- Sessions are **auto-restored when tmux starts**
- Survives system reboots

### Manual Controls:

| Action | Keys |
|--------|------|
| Save session | `Ctrl+b Ctrl+s` |
| Restore session | `Ctrl+b Ctrl+r` |

Saved sessions are stored in `~/.tmux/resurrect/`.

---

## Configuration

### Reload Config

After editing `~/.tmux.conf`:

| Action | Keys |
|--------|------|
| Reload config | `Ctrl+b r` |

### Config Location

```
~/.tmux.conf → symlink to ~/maximum-awesome/tmux.conf
```

### Installed Plugins (via TPM)

| Plugin | Purpose |
|--------|---------|
| `tmux-sensible` | Sensible default settings |
| `tmux-yank` | Copy to system clipboard |
| `tmux-resurrect` | Save/restore sessions |
| `tmux-continuum` | Auto-save sessions |

### Managing Plugins

| Action | Keys |
|--------|------|
| Install plugins | `Ctrl+b I` |
| Update plugins | `Ctrl+b U` |
| Uninstall removed plugins | `Ctrl+b Alt+u` |

---

## Status Bar

The status bar shows:

```
[hostname] • [kernel] | [windows] | [mem/cpu] [uptime] [time] [date]
```

- **Left:** Hostname and kernel version
- **Center:** Window list (current window highlighted in orange)
- **Right:** System stats, time, and date

---

## Quick Reference Card

### Essential Commands

| I want to... | Keys |
|--------------|------|
| Split pane horizontally | `Ctrl+b v` |
| Split pane vertically | `Ctrl+b b` |
| Move between panes | `Ctrl+b h/j/k/l` |
| Create new window | `Ctrl+b c` |
| Switch windows | `Ctrl+b 1-9` |
| Scroll up | Mouse wheel or `Ctrl+b [` |
| Copy text | Select with mouse, press `Enter` |
| Paste text | `Ctrl+b ]` |
| Zoom pane (fullscreen) | `Ctrl+b z` |
| Detach session | `Ctrl+b d` |
| Reload config | `Ctrl+b r` |

### Pro Tips

1. **Use named sessions** for different projects: `tmux new -s projectname`
2. **Zoom a pane** with `Ctrl+b z` when you need more space temporarily
3. **Let continuum handle saves** - your sessions persist automatically
4. **Use vim-style navigation** (`h/j/k/l`) - it's faster than arrow keys
5. **Mouse scrolling** is the quickest way to view output history

---

## Troubleshooting

### Colors look wrong

Ensure your terminal supports 256 colors and set:
```bash
export TERM=screen-256color
```

### Mouse not working

Mouse support requires tmux 2.1+. Check version:
```bash
tmux -V
```

### Plugins not loading

Run `Ctrl+b I` to install plugins, then `Ctrl+b r` to reload.

### Copy not working to system clipboard

The `tmux-yank` plugin handles this. On macOS, it should work automatically. On Linux, you may need `xclip` or `xsel`:
```bash
# Ubuntu/Debian
sudo apt install xclip
```
