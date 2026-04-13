#!/bin/bash
# ─────────────────────────────────────────────────────────────
# setup-macos.sh — script the macOS system preferences that
# would otherwise require tedious clicking through System
# Settings. Safe to run multiple times.
#
# Usage: bash setup-macos.sh
# ─────────────────────────────────────────────────────────────

set -e

echo "→ Applying macOS system preferences..."

# ── Trackpad ─────────────────────────────────────────────────
# Tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Three-finger drag (hidden in Accessibility → Pointer Control → Trackpad Options)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

# ── Text input — disable the "smart" substitutions that ruin
# copy-pasted shell commands (em-dash, curly quotes, etc.) ──
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# ── Finder ───────────────────────────────────────────────────
# Show hidden files (incl. .env, .ssh, .gitignore etc)
defaults write com.apple.finder AppleShowAllFiles -bool true
# Show path bar + status bar
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
# Always show file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Default new Finder window to home
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
# Default to List View (Nlsv=List, icnv=Icon, clmv=Column, glyv=Gallery)
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"
# Sort by Kind (폴더가 자연스럽게 상단에 모임)
defaults write com.apple.finder FXArrangeGroupViewBy -string "Kind"

# ── Keyboard ─────────────────────────────────────────────────
# Fast key repeat (minimum = 2 = fastest allowed via UI)
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# ── Screenshots ──────────────────────────────────────────────
# Save screenshots to ~/Screenshots instead of cluttering Desktop
mkdir -p "${HOME}/Screenshots"
defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
defaults write com.apple.screencapture type -string "png"

# ── Dock ─────────────────────────────────────────────────────
# Auto-hide for more screen space, instant reveal on hover.
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.3
# No magnification — icons stay put.
defaults write com.apple.dock magnification -bool false
# Don't clutter the Dock with recently-used apps.
defaults write com.apple.dock show-recents -bool false
# Slightly smaller icons (48px vs default 64).
defaults write com.apple.dock tilesize -int 48

# ── Dock items — reset to minimal layout ─────────────────────
if command -v dockutil &>/dev/null; then
  dockutil --remove all --no-restart
  dockutil --add /System/Applications/System\ Settings.app --no-restart
  dockutil --add ~/Downloads --section others --view list --display folder --no-restart
fi

# ── Menu bar ─────────────────────────────────────────────────
# Show battery percentage next to the battery icon.
defaults write com.apple.controlcenter BatteryShowPercentage -bool true

# Clock: show date + day of week + 24-hour time with seconds.
# macOS 14+ ignores the legacy DateFormat string and composes
# the clock display from these individual toggles instead.
# The exact layout (e.g. "4월 10일 (금) 09:56:23") is driven by
# the Korean locale; we just control what's shown/hidden.
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true
defaults write com.apple.menuextra.clock ShowDate -int 1      # always show date
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowAMPM -bool false
defaults write com.apple.menuextra.clock ShowSeconds -bool true
defaults write com.apple.menuextra.clock IsAnalog -bool false

# ── Mission Control ──────────────────────────────────────────
# Don't auto-rearrange spaces by most-recent-use — keep them
# in the order you created them so muscle memory works.
defaults write com.apple.dock mru-spaces -bool false
# Show each window separately instead of grouping by app.
defaults write com.apple.dock expose-group-apps -bool false

# ── Appearance ───────────────────────────────────────────────
# Force dark mode (matches Ghostty/Starship/VS Code Catppuccin).
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# ── Window Manager ───────────────────────────────────────────
# Disable "click desktop to show Desktop" (macOS 14+ annoyance).
# Prevents accidentally hiding all windows by clicking wallpaper.
defaults write com.apple.WindowManager EnableStandardClickToShowDesktop -bool false

# ── Save / Open dialogs ──────────────────────────────────────
# Expand save panels by default (full Finder-like browser).
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
# Expand print panels by default too.
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# ── Keyboard accessibility ───────────────────────────────────
# Tab cycles through all UI controls, not just text fields.
# Lets you drive dialogs keyboard-only (Tab + Space).
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

# ── Sound ────────────────────────────────────────────────────
# Mute the startup chime (prompts for sudo password once).
sudo nvram StartupMute=%01

# Note: DNS is handled at the router level (KT home router →
# Cloudflare 1.1.1.1), so no per-interface DNS override needed
# here. Other Wi-Fi networks (office, cafes) keep their own
# DHCP-provided DNS automatically.

# ── Hot Corners ──────────────────────────────────────────────
# Actions: 0=none, 2=Mission Control, 4=Desktop, 13=Lock, 14=Quick Note
# tl = top-left, tr = top-right, bl = bottom-left, br = bottom-right
defaults write com.apple.dock wvous-tl-corner -int 13   # Lock Screen
defaults write com.apple.dock wvous-tl-modifier -int 0
defaults write com.apple.dock wvous-tr-corner -int 2    # Mission Control
defaults write com.apple.dock wvous-tr-modifier -int 0
defaults write com.apple.dock wvous-bl-corner -int 14   # Quick Note
defaults write com.apple.dock wvous-bl-modifier -int 0
defaults write com.apple.dock wvous-br-corner -int 4    # Desktop
defaults write com.apple.dock wvous-br-modifier -int 0

# ── Touch ID for sudo ───────────────────────────────────────
# Enable fingerprint authentication for the `sudo` command.
# Uses /etc/pam.d/sudo_local (macOS 14+) so the setting survives
# system updates — unlike editing /etc/pam.d/sudo directly.
if [ ! -f /etc/pam.d/sudo_local ]; then
  echo "→ Enabling Touch ID for sudo (requires password once)..."
  sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local
  # Uncomment the `auth sufficient pam_tid.so` line.
  sudo sed -i '' 's/^#auth/auth/' /etc/pam.d/sudo_local
fi

# ── Apply changes ────────────────────────────────────────────
killall Finder 2>/dev/null || true
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "✓ macOS preferences applied."
