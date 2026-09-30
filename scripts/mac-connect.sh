#!/usr/bin/env bash
# Mac をこのプロジェクトのクラウド側 Claude から操作できるようにする。
# 公式の Remote Control(`claude remote-control`)で ~/sts2-mods フォルダを接続する。
# 使い方(Mac のターミナルに貼る):
#   bash -c "$(curl -fsSL https://raw.githubusercontent.com/masseater/sts2-mods/main/scripts/mac-connect.sh)"
set -euo pipefail

REPO_DIR="${STS2_REPO_DIR:-$HOME/sts2-mods}"

# Claude Code が無ければ公式インストーラで入れる
if ! command -v claude >/dev/null 2>&1; then
  echo "==> Claude Code をインストールします"
  curl -fsSL https://claude.ai/install.sh | bash
  export PATH="$HOME/.local/bin:$PATH"
fi

# 作業フォルダ(リポジトリ)を用意する
if [ ! -d "$REPO_DIR/.git" ]; then
  echo "==> リポジトリを $REPO_DIR に clone します"
  git clone https://github.com/masseater/sts2-mods.git "$REPO_DIR"
fi
cd "$REPO_DIR"

echo "==> Remote Control を開始します(ログインを求められたらブラウザで許可してください)"
echo "    このウィンドウは閉じずにそのままにしてください。止めるときは Ctrl+C"
# 接続中に Mac がスリープしないよう caffeinate で包む
exec caffeinate -i claude remote-control
