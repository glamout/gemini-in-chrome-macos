#!/bin/bash
set -u

PROJECT_DIR="$(cd "$(/usr/bin/dirname "$0")" && /bin/pwd)"
/bin/bash "$PROJECT_DIR/scripts/install.sh"
RESULT=$?

echo
if [[ "$RESULT" -eq 0 ]]; then
  echo "安装流程已完成。按回车关闭此窗口。"
else
  echo "安装未完成（退出码：$RESULT）。请查看上方提示；按回车关闭此窗口。"
fi
read -r _
exit "$RESULT"
