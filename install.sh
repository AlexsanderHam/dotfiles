#!/bin/bash
# ─────────────────────────────────────────────────────────────
# install.sh — Mac 완전 자동 셋업
#
# 포맷 후 터미널에서 이 한 줄만 실행하면 끝:
#
#   bash <(curl -s https://raw.githubusercontent.com/alexsanderham/dotfiles/main/install.sh)
#
# 또는 이미 clone 되어 있으면:
#
#   bash ~/dotfiles/install.sh
# ─────────────────────────────────────────────────────────────

set -e

# ── 0. GitHub 에서 dotfiles clone ─────────────────────────────
GITHUB_REPO="https://github.com/alexsanderham/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

if [ ! -d "$DOTFILES_DIR/.git" ]; then
  if [ -d "$DOTFILES_DIR" ]; then
    echo "→ 기존 ~/dotfiles 백업 중..."
    mv "$DOTFILES_DIR" "$DOTFILES_DIR.backup.$(date +%s)"
  fi
  echo "→ dotfiles clone 중..."
  git clone "$GITHUB_REPO" "$DOTFILES_DIR"
  chmod +x "$DOTFILES_DIR"/install.sh "$DOTFILES_DIR"/scripts/*.sh
  echo "  ✓ clone 완료. 거기서 다시 실행합니다."
  exec bash "$DOTFILES_DIR/install.sh"
fi

cd "$DOTFILES_DIR"
git pull --ff-only 2>/dev/null || true

# ── 1. Xcode Command Line Tools ──────────────────────────────
if ! xcode-select -p &>/dev/null; then
  echo "→ Xcode Command Line Tools 설치 중... (팝업 창에서 '설치' 클릭)"
  xcode-select --install
  echo "  설치 완료될 때까지 기다려주세요. 완료되면 Enter 를 눌러주세요."
  read -r
fi

# ── 2. Homebrew ───────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
  echo "→ Homebrew 설치 중..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# ── 3. Brewfile 설치 ──────────────────────────────────────────
echo "→ Brewfile bundle 설치 중... (시간 좀 걸림)"
brew bundle install --file="$DOTFILES_DIR/Brewfile"

# ── 4. 홈 dotfiles 심볼릭 링크 ────────────────────────────────
echo "→ 홈 dotfiles 링크 중..."
link_home() {
  local src="$DOTFILES_DIR/home/$1"
  local dest="$HOME/$1"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "${dest}.backup"
  fi
  ln -sf "$src" "$dest"
  echo "  ✓ ~/$1"
}

link_home .zshrc
link_home .gitconfig
link_home .gitignore_global

# ── 5. ~/.config 심볼릭 링크 (Ghostty, Starship, Neovim) ──────
echo "→ ~/.config 링크 중..."
mkdir -p "$HOME/.config/ghostty"

link_config() {
  local src="$DOTFILES_DIR/config/$1"
  local dest="$HOME/.config/$1"
  if [ -e "$dest" ] && [ ! -L "$dest" ]; then
    mv "$dest" "${dest}.backup"
  fi
  ln -sfn "$src" "$dest"
  echo "  ✓ ~/.config/$1"
}

link_config ghostty/config
link_config starship.toml
link_config nvim

# ── 5.1. Claude Code 설정 ─────────────────────────────────────
echo "→ Claude Code 설정 링크 중..."
mkdir -p "$HOME/.claude"
if [ -e "$HOME/.claude/settings.json" ] && [ ! -L "$HOME/.claude/settings.json" ]; then
  mv "$HOME/.claude/settings.json" "$HOME/.claude/settings.json.backup"
fi
ln -sf "$DOTFILES_DIR/config/claude/settings.json" "$HOME/.claude/settings.json"
echo "  ✓ ~/.claude/settings.json"

# ── 5.2. Ice (메뉴바) 설정 ────────────────────────────────────
echo "→ Ice 설정 복사 중..."
cp "$DOTFILES_DIR/config/ice/com.jordanbaird.Ice.plist" "$HOME/Library/Preferences/com.jordanbaird.Ice.plist"
echo "  ✓ Ice 설정"

# ── 5.3. Stats (시스템 모니터) 설정 ────────────────────────────
echo "→ Stats 설정 복사 중..."
cp "$DOTFILES_DIR/config/stats/eu.exelban.Stats.plist" "$HOME/Library/Preferences/eu.exelban.Stats.plist"
echo "  ✓ Stats 설정"

# ── 5.4. Pear Desktop (YouTube Music) 설정 ────────────────────
echo "→ Pear Desktop 설정 중..."
PEAR_CONFIG_DIR="$HOME/Library/Application Support/YouTube Music"
mkdir -p "$PEAR_CONFIG_DIR"
cat > "$PEAR_CONFIG_DIR/config.json" <<PEAR_EOF
{
  "window-size": {"width": 1100, "height": 750},
  "window-maximized": false,
  "options": {
    "tray": false,
    "appVisible": true,
    "autoUpdates": true,
    "resumeOnStart": true,
    "themes": ["$DOTFILES_DIR/config/youtube-music-catppuccin-mocha.css"],
    "language": "ko"
  },
  "plugins": {
    "synced-lyrics": {"enabled": true},
    "compact-sidebar": {"enabled": true},
    "video-toggle": {"mode": "custom"},
    "discord": {"listenAlong": true},
    "navigation": {"enabled": false}
  },
  "__internal__": {
    "migrations": {"version": "3.11.0"}
  }
}
PEAR_EOF
echo "  ✓ Pear Desktop 설정 + Catppuccin 테마"

# ── 6. VS Code 설정 + 확장 ────────────────────────────────────
echo "→ VS Code 설정 링크 중..."
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
if [ -e "$VSCODE_USER/settings.json" ] && [ ! -L "$VSCODE_USER/settings.json" ]; then
  mv "$VSCODE_USER/settings.json" "$VSCODE_USER/settings.json.backup"
fi
ln -sf "$DOTFILES_DIR/config/vscode/settings.json" "$VSCODE_USER/settings.json"
echo "  ✓ VS Code settings.json"

if command -v code &>/dev/null; then
  echo "→ VS Code 확장 설치 중..."
  grep -v '^#' "$DOTFILES_DIR/config/vscode/extensions.txt" | grep -v '^$' | while read -r ext; do
    code --install-extension "$ext" --force 2>&1 | grep -q "already installed" && echo "  ✓ $ext (이미 설치)" || echo "  ✓ $ext"
  done
else
  echo "  ! VS Code 아직 안 열림. 첫 실행 후 Cmd+Shift+P → 'Shell Command: Install' 하세요."
fi

# ── 7. macOS 시스템 설정 ──────────────────────────────────────
echo "→ macOS 시스템 설정 적용 중..."
bash "$DOTFILES_DIR/scripts/setup-macos.sh"

# ── 8. Docker Compose 플러그인 링크 + colima 초기화 ────────────
echo "→ Docker Compose 플러그인 링크..."
mkdir -p "$HOME/.docker/cli-plugins"
ln -sfn /opt/homebrew/opt/docker-compose/bin/docker-compose \
  "$HOME/.docker/cli-plugins/docker-compose" 2>/dev/null || true

# Start colima with proper resources (only on first run).
if ! colima status &>/dev/null; then
  echo "→ colima 초기화 (CPU 4, RAM 8GB, Disk 100GB)..."
  colima start --cpu 4 --memory 8 --disk 100
fi

# ── 9. 런타임 설치 (mise, Bun, Rust, Claude Code) ─────────────
eval "$(/opt/homebrew/bin/mise activate bash)"

echo "→ Node LTS 설치 (mise)..."
mise use --global node@lts

echo "→ Java 21 Temurin 설치 (mise)..."
mise use --global java@temurin-21

# Register Java with macOS so DataGrip/IntelliJ can auto-detect it.
JAVA_VERSION=$(mise current java 2>/dev/null | sed 's/temurin-//')
JAVA_HOME_DIR="$HOME/.local/share/mise/installs/java/temurin-${JAVA_VERSION}"
JVM_DIR="/Library/Java/JavaVirtualMachines/temurin-${JAVA_VERSION}.jdk"
if [ -d "$JAVA_HOME_DIR/Contents" ] && [ ! -d "$JVM_DIR" ]; then
  echo "→ Java macOS 통합 (DataGrip 자동 감지용)..."
  sudo mkdir -p "$JVM_DIR" 2>/dev/null || true
  sudo ln -sfn "$JAVA_HOME_DIR/Contents" "$JVM_DIR/Contents" 2>/dev/null || true
fi

echo "→ Bun 설치 (mise)..."
mise use --global bun@latest

echo "→ Python 설치 (mise)..."
mise use --global python@3

echo "→ pnpm 설치 (mise)..."
mise use --global pnpm@latest

# Rust PATH must be set BEFORE the check so re-runs find cargo.
export PATH="$HOME/.cargo/bin:$PATH"

if ! command -v cargo &>/dev/null; then
  echo "→ Rust 설치 (rustup)..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
fi

echo "→ Rust 추가 도구 설치..."
command -v cargo-watch &>/dev/null || cargo install cargo-watch   # 파일 변경 시 자동 재빌드
command -v sccache &>/dev/null || cargo install sccache           # 빌드 캐시

if ! command -v claude &>/dev/null; then
  echo "→ Claude Code 설치 (npm global)..."
  npm install -g @anthropic-ai/claude-code
fi

# ── 10. bat Catppuccin 테마 설치 ──────────────────────────────
if command -v bat &>/dev/null; then
  echo "→ bat Catppuccin 테마 설치..."
  BAT_THEMES="$(bat --config-dir)/themes"
  mkdir -p "$BAT_THEMES"
  curl -sLo "$BAT_THEMES/Catppuccin Mocha.tmTheme" \
    "https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme" 2>/dev/null || true
  bat cache --build &>/dev/null || true
  echo '--theme="Catppuccin Mocha"' > "$(bat --config-dir)/config"
  echo "  ✓ bat Catppuccin Mocha"
fi

echo
echo "═══════════════════════════════════════════════════════════"
echo "✓ 설치 완료!"
echo "═══════════════════════════════════════════════════════════"
echo
echo "터미널 재시작하세요 (Ghostty 열기)."
echo
echo "수동 설정 체크리스트:"
echo "  □ 배경화면 + 바탕화면 위젯 배치"
echo "  □ 메뉴 막대 아이콘 정리"
echo "  □ Raycast / Rectangle / AltTab / Stats / Ice / Ghostty → 접근성 권한 + 로그인 시 시작"
echo "  □ Chrome / Brave / Firefox → 계정 로그인"
echo "  □ KakaoTalk → App Store 설치 + 로그인"
echo "  □ Slack / Discord → 계정 로그인"
echo "  □ DataGrip → JetBrains 라이선스"
echo "  □ Notion / Obsidian → 계정 / vault 설정"
echo "  □ Pear Desktop → 재시작 (테마 적용) + Google 로그인"
echo "  □ Claude Code → claude 실행 후 로그인"
echo "  □ Neovim → nvim 실행하여 플러그인 초기 설치"
echo "  □ AppCleaner / Keka → 첫 실행 + Keka 기본 앱 설정"
echo "  □ Spotlight 비활성화 (Raycast 대체)"
echo "  □ 화면 밝기 자동 조절 끄기"
echo
echo "SSH 키 복구:"
SSH_DMG="$HOME/Library/Mobile Documents/com~apple~CloudDocs/ssh-backup.dmg"
if [ -f "$SSH_DMG" ]; then
  read -rp "  iCloud 에서 ssh-backup.dmg 발견. 복구할까요? (y/N) " yn
  if [[ "$yn" =~ ^[Yy]$ ]]; then
    hdiutil attach "$SSH_DMG" -nobrowse -quiet
    mkdir -p ~/.ssh
    cp -R /Volumes/ssh-backup/* ~/.ssh/
    chmod 700 ~/.ssh
    chmod 600 ~/.ssh/alexsanderham ~/.ssh/config
    ssh-keyscan -t rsa,ed25519 github.com >> ~/.ssh/known_hosts 2>/dev/null
    ssh-add --apple-use-keychain ~/.ssh/alexsanderham 2>/dev/null
    hdiutil detach /Volumes/ssh-backup -quiet
    echo "  ✓ SSH 키 복구 완료 (Keychain 등록됨)"
  fi
else
  echo "  ! ssh-backup.dmg 가 iCloud 에 없습니다. iCloud 동기화 후 수동 복구:"
  echo "    hdiutil attach ~/Library/Mobile\\ Documents/com~apple~CloudDocs/ssh-backup.dmg"
  echo "    cp -R /Volumes/ssh-backup/* ~/.ssh/ && chmod 700 ~/.ssh"
fi
