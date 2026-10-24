#!/bin/bash
set -euo pipefail

APP_NAME="Gemini in Chrome Launcher.app"
TARGET="$HOME/Applications/$APP_NAME"
WORK_DIR=""
CHROME_APP=""

cleanup() {
  if [[ -n "$WORK_DIR" && -d "$WORK_DIR" ]]; then
    /bin/rm -rf "$WORK_DIR"
  fi
}
trap cleanup EXIT

if [[ "$(/usr/bin/uname -s)" != "Darwin" ]]; then
  echo "此安装脚本仅支持 macOS。" >&2
  exit 1
fi

if ! /usr/bin/open -Ra "Google Chrome" >/dev/null 2>&1; then
  echo "未检测到 Google Chrome。请先安装 Chrome 后重试。" >&2
  exit 1
fi

if ! command -v /usr/bin/osacompile >/dev/null 2>&1; then
  echo "未找到 macOS AppleScript 编译工具 osacompile，无法创建启动器。" >&2
  exit 1
fi

CHROME_APP="$(/usr/bin/osascript -e 'POSIX path of (path to application "Google Chrome")' 2>/dev/null || true)"
if [[ -n "$CHROME_APP" && -f "$CHROME_APP/Contents/Info.plist" ]]; then
  CHROME_VERSION="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "$CHROME_APP/Contents/Info.plist" 2>/dev/null || true)"
else
  CHROME_VERSION="未知"
fi

if [[ -e "$TARGET" ]]; then
  echo "启动器已存在：$TARGET" >&2
  echo "为避免覆盖其他应用，请先手动移动或重命名它，再运行安装脚本。" >&2
  exit 1
fi

/bin/mkdir -p "$HOME/Applications"
WORK_DIR="$(/usr/bin/mktemp -d "${TMPDIR:-/tmp}/glic-launcher.XXXXXX")"

cat > "$WORK_DIR/launcher.applescript" <<'APPLESCRIPT'
do shell script "/usr/bin/open -a 'Google Chrome' --args --enable-features=Glic,GlicRollout --disable-features=GlicCountryFiltering"
APPLESCRIPT

/usr/bin/osacompile -o "$WORK_DIR/$APP_NAME" "$WORK_DIR/launcher.applescript"
/bin/mv "$WORK_DIR/$APP_NAME" "$TARGET"

echo "已安装：$TARGET"
echo "检测到 Chrome 版本：${CHROME_VERSION:-未知}"
echo "启动器参数：--enable-features=Glic,GlicRollout --disable-features=GlicCountryFiltering"

if /usr/bin/pgrep -x "Google Chrome" >/dev/null 2>&1; then
  echo "Chrome 当前正在运行。为避免关闭未保存的工作，安装器没有退出 Chrome。"
  echo "请先保存工作并按 ⌘Q 完全退出 Chrome，再打开新建的启动器。"
else
  echo "Chrome 当前未运行，正在通过新启动器打开。"
  if ! /usr/bin/open "$TARGET"; then
    echo "启动器已安装，但自动打开失败。请在 ~/Applications 中手动打开它。" >&2
  fi
fi

echo "资格提醒：按钮能否使用还取决于账号、支持地区、语言、首次启用和 Google 服务端策略。"
