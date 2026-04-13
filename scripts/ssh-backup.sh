#!/bin/bash
# ─────────────────────────────────────────────────────────────
# ssh-backup.sh — ~/.ssh 를 암호화된 DMG 로 묶어 iCloud 에 저장
#
# Usage: bash ~/dotfiles/scripts/ssh-backup.sh
# ─────────────────────────────────────────────────────────────

set -e

ICLOUD_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs"
DMG_PATH="$ICLOUD_DIR/ssh-backup.dmg"
TMP_DMG="/tmp/ssh-backup.dmg"

if [ ! -d "$HOME/.ssh" ]; then
  echo "✗ ~/.ssh 가 없습니다."
  exit 1
fi

if [ ! -d "$ICLOUD_DIR" ]; then
  echo "✗ iCloud Drive 를 찾을 수 없습니다."
  exit 1
fi

echo "→ ~/.ssh 를 암호화된 DMG 로 백업합니다."
echo "  DMG 암호를 설정하세요 (포맷 후 복구 시 필요):"

# 키 파일만 임시 폴더로 복사 (소켓, .DS_Store 등 제외)
TMP_SRC="/tmp/ssh-backup-src"
rm -rf "$TMP_SRC" "$TMP_DMG"
mkdir -p "$TMP_SRC"
find "$HOME/.ssh" -maxdepth 1 -type f \
  ! -name ".DS_Store" ! -name "known_hosts.old" \
  -exec cp {} "$TMP_SRC/" \;

# 암호화된 DMG 생성
hdiutil create "$TMP_DMG" \
  -srcfolder "$TMP_SRC" \
  -encryption AES-256 \
  -volname "ssh-backup" \
  -format UDZO \
  -quiet

# 정리 + iCloud 로 이동
rm -rf "$TMP_SRC"
mv -f "$TMP_DMG" "$DMG_PATH"

echo "✓ 백업 완료: $DMG_PATH"
echo "  iCloud 동기화가 자동으로 진행됩니다."
