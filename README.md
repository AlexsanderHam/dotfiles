# dotfiles

macOS 환경 설정 및 개발 도구 자동 설치 스크립트

```sh
bash <(curl -s https://raw.githubusercontent.com/AlexsanderHam/dotfiles/main/install.sh)
```

## 자동으로 하는 일

- Xcode CLT + Homebrew + [Brewfile](Brewfile) 전체 설치
- dotfiles 심볼릭 링크 (`.zshrc`, `.gitconfig` 등)
- 앱 설정 복원 (Ghostty, Starship, Neovim, Claude Code, VS Code, Ice, Stats, Pear Desktop)
- macOS 시스템 설정 (트랙패드, Dock, Finder, 핫코너, 다크 모드 등)
- 런타임 설치 (Node LTS, Java 21, Bun, Python 3, pnpm, Rust)
- SSH 키 복구 (iCloud DMG 자동 감지)

## 수동 체크리스트

- [ ] 배경화면 + 바탕화면 위젯 배치
- [ ] 메뉴 막대 아이콘 정리
- [ ] Raycast / Rectangle / AltTab / Stats / Ice / Ghostty → 접근성 권한 + 로그인 시 시작
- [ ] Chrome / Brave / Firefox → 계정 로그인
- [ ] KakaoTalk → App Store 설치 + 로그인
- [ ] Slack / Discord → 계정 로그인
- [ ] DataGrip → JetBrains 라이선스
- [ ] Notion / Obsidian → 계정 / vault 설정
- [ ] Pear Desktop → 재시작 (테마 적용) + Google 로그인
- [ ] Claude Code → `claude` 실행 후 로그인
- [ ] Neovim → `nvim` 실행하여 플러그인 초기 설치
- [ ] AppCleaner / Keka → 첫 실행 + Keka 기본 앱 설정
- [ ] Spotlight 비활성화 (Raycast 대체)
- [ ] 화면 밝기 자동 조절 끄기

## SSH 키 백업

```sh
bash ~/dotfiles/scripts/ssh-backup.sh
```

`~/.ssh`를 AES-256 암호화 DMG로 묶어 iCloud Drive에 저장. 설치 시 자동 감지 후 복구.

## 파일 구조

```text
├── install.sh              ← 이것만 실행하면 끝
├── Brewfile                ← 앱/도구 목록
├── scripts/
│   ├── setup-macos.sh      ← macOS 시스템 설정
│   └── ssh-backup.sh       ← SSH 키 → iCloud 백업
├── home/                   ← ~/ 에 심볼릭 링크
│   ├── .zshrc
│   ├── .gitconfig
│   └── .gitignore_global
└── config/                 ← 앱 설정 파일
    ├── ghostty/            ← 터미널 (Catppuccin + Quick Terminal)
    ├── starship.toml       ← 프롬프트
    ├── nvim/               ← LazyVim
    ├── claude/             ← Claude Code 플러그인
    ├── ice/                ← 메뉴바 배치
    ├── stats/              ← 시스템 모니터 위젯
    └── vscode/             ← 에디터 설정 + 확장 목록
```

## 테마

Catppuccin Mocha — Ghostty, VS Code, Neovim, Starship, bat, YouTube Music, macOS 다크 모드
