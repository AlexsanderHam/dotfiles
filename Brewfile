# ─────────────────────────────────────────────────────────────
# Brewfile — install with: `brew bundle install`
# ─────────────────────────────────────────────────────────────

# ── CLI tooling ──────────────────────────────────────────────
brew "git"
brew "gh"                                          # GitHub CLI
brew "starship"                                    # cross-shell prompt
brew "mise"                                        # unified version manager — Node, Java, Go, etc.
brew "fzf"                                         # fuzzy finder — upgrades Ctrl+R history search
brew "zsh-autosuggestions"                         # fish-like history suggestions while typing
brew "zsh-syntax-highlighting"                     # red/green command validation as you type
brew "bat"                                         # cat with syntax highlighting (aliased to cat)
brew "eza"                                         # ls with icons + git status (aliased to ls)
brew "dockutil"                                    # Dock item management from CLI

# ── Container runtime (Docker Desktop-free) ──────────────────
brew "colima", restart_service: :changed           # docker daemon in a tiny VM
brew "docker"                                      # docker CLI
brew "docker-compose"                              # provides `docker compose` plugin
                                                   # (post-install.sh symlinks it into ~/.docker/cli-plugins)

# ── Fonts ────────────────────────────────────────────────────
cask "font-jetbrains-mono-nerd-font"               # terminal + editor font
cask "font-pretendard"                             # Korean UI/body font (system-wide)

# ── Terminal & editor ────────────────────────────────────────
cask "ghostty"                                     # primary terminal
cask "visual-studio-code"                          # primary editor
brew "neovim"                                      # terminal editor (LazyVim)

# ── Productivity / launcher ──────────────────────────────────
cask "raycast"                                     # Spotlight replacement + clipboard + window mgmt
cask "rectangle"                                   # window snap via keyboard shortcuts
cask "alt-tab"                                     # Windows-style per-window Cmd+Tab with previews
cask "stats"                                       # menu bar system monitor (CPU/RAM/network/temp)
cask "keka"                                        # archive extractor + compressor (rar, 7z, zip)
cask "appcleaner"                                  # clean app uninstall (removes leftovers)
cask "jordanbaird-ice"                             # menu bar manager (hide/reveal icons)

# ── Browsers ─────────────────────────────────────────────────
cask "google-chrome"                               # main dev browser
cask "brave-browser"                               # daily browsing + ad block
cask "firefox@developer-edition"                   # cross-browser testing + CSS Grid Inspector

# ── Messaging ────────────────────────────────────────────────
cask "discord"
cask "slack"

# Mac App Store apps — install manually from App Store:
#   - KakaoTalk

# ── Database IDE ─────────────────────────────────────────────
cask "datagrip"                                    # JetBrains DB IDE

# ── Notes / docs ─────────────────────────────────────────────
cask "notion"                                      # team wiki + docs + databases
cask "obsidian"                                    # personal knowledge base (local markdown)

# ── Music ────────────────────────────────────────────────────
tap "pear-devs/pear"
cask "pear-devs/pear/pear-desktop"                 # YouTube Music desktop (Catppuccin theme in dotfiles/config/)
