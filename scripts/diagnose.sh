#!/bin/bash
set -euo pipefail

TARGET="$HOME/Applications/Gemini in Chrome Launcher.app"
CHROME_APP=""

if [[ "$(/usr/bin/uname -s)" != "Darwin" ]]; then
  echo "此诊断脚本仅支持 macOS。" >&2
  exit 1
fi

if /usr/bin/open -Ra "Google Chrome" >/dev/null 2>&1; then
  echo "Google Chrome：已检测到"
  CHROME_APP="$(/usr/bin/osascript -e 'POSIX path of (path to application "Google Chrome")' 2>/dev/null || true)"
  if [[ -n "$CHROME_APP" && -f "$CHROME_APP/Contents/Info.plist" ]]; then
    CHROME_VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$CHROME_APP/Contents/Info.plist" 2>/dev/null || true)"
    echo "Chrome 版本：${CHROME_VERSION:-未知}"
  fi
else
  echo "Google Chrome：未检测到，请先安装 Chrome。" >&2
  exit 1
fi

if [[ ! -d "$TARGET" ]]; then
  echo "启动器：未安装（预期位置：$TARGET）"
  exit 1
fi

echo "启动器：已安装（$TARGET）"
SCRIPT_PATH="$TARGET/Contents/Resources/Scripts/main.scpt"
if [[ ! -f "$SCRIPT_PATH" ]]; then
  echo "未找到 AppleScript 文件：$SCRIPT_PATH" >&2
  exit 1
fi

echo "启动器脚本："
LAUNCHER_SCRIPT="$(/usr/bin/osadecompile "$SCRIPT_PATH")"
echo "$LAUNCHER_SCRIPT"

if [[ "$LAUNCHER_SCRIPT" != *"--enable-features=Glic,GlicRollout"* || "$LAUNCHER_SCRIPT" != *"--disable-features=GlicCountryFiltering"* ]]; then
  echo "启动器参数与本项目预期不一致；请重新安装或检查启动器。" >&2
  exit 1
fi
echo "启动器参数：检查通过"

if /usr/bin/pgrep -x "Google Chrome" >/dev/null 2>&1; then
  RUNNING_COMMANDS="$(/bin/ps -ax -o command=)"
  if [[ "$RUNNING_COMMANDS" == *"--enable-features=Glic,GlicRollout"* && "$RUNNING_COMMANDS" == *"--disable-features=GlicCountryFiltering"* ]]; then
    echo "当前 Chrome 进程：检测到本项目启动参数"
  else
    echo "当前 Chrome 进程：未检测到本项目启动参数。请保存工作、按 ⌘Q 完全退出，再从启动器打开。"
  fi
else
  echo "当前 Chrome 进程：未运行"
fi

echo "账号、地区、语言、同意流程和 Google 服务端资格无法由本脚本确认。打开 Chrome 后可在 chrome://glic/internals 查看。"
