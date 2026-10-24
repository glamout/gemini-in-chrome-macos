#!/bin/bash
set -euo pipefail

TARGET="$HOME/Applications/Gemini in Chrome Launcher.app"

if [[ ! -d "$TARGET" ]]; then
  echo "未找到启动器：$TARGET"
  exit 0
fi

/bin/rm -rf "$TARGET"
echo "已移除：$TARGET"
