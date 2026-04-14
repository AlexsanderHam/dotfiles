# ─────────────────────────────────────────────────────────────
# ~/.zshrc — interactive shell config
# ─────────────────────────────────────────────────────────────

# Homebrew (Apple Silicon location)
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"

# ── mise (Node / Java / Bun version manager) ───────────────
# Replaces nvm. Handles Node, Java, Bun in one tool.
eval "$(mise activate zsh)"

# ── Rust / cargo ────────────────────────────────────────────
export PATH="$HOME/.cargo/bin:$PATH"

# ── pnpm global bin (for `pnpm add -g` packages) ──
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"

# ── Local bin (Claude Code native installer, etc.) ──
export PATH="$HOME/.local/bin:$PATH"

# ── Zsh plugins ─────────────────────────────────────────────
# Autosuggestions: gray history-based suggestions while typing.
# Accept with → key, ignore by continuing to type.
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

# Syntax highlighting: valid commands = green, typos = red.
# Must be loaded AFTER all other plugins (zsh requirement).
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null

# ── fzf (fuzzy finder) ──────────────────────────────────────
# Upgrades Ctrl+R to a full-screen fuzzy search UI.
# Also adds Ctrl+T (file search) and Alt+C (cd into dir).
source <(fzf --zsh) 2>/dev/null

# ── Aliases ─────────────────────────────────────────────────
# Neovim (LazyVim) as default editor.
alias vim="nvim"
alias vi="nvim"

# bat → cat: syntax highlighting + line numbers only.
# No header/footer/grid, no paging, terminal handles reflow.
alias cat="bat --paging=never --wrap=never --style=numbers"

# eza → ls/ll/tree: icons (Nerd Font), colors, git status.
alias ls="eza --icons"
alias ll="eza -la --icons --git"
alias tree="eza --tree --icons"

# ── Starship prompt ─────────────────────────────────────────
eval "$(starship init zsh)"
