# よく使うコマンドのまとめ。Mac / Linux 用 (Windows は scripts/*.ps1 か dotnet を直接)。
# 例: make check / make fix / make build MOD=MapDrawUndo / make new MOD=NewMod

MOD ?=

.PHONY: help check fix build publish pck stage new hooks

help:
	@echo "make check            静的検査 (整形・型チェック・アナライザ・マニフェスト)。コミット前と CI と同じ"
	@echo "make fix              整形とコードスタイルを自動修正してから検査"
	@echo "make build [MOD=名前]  ビルドしてゲームの mods フォルダへ配置 (MOD 省略で全部)"
	@echo "make publish MOD=名前  .pck も書き出して配置"
	@echo "make pck MOD=名前      .pck だけ書き出す (ゲーム不要)"
	@echo "make stage MOD=名前    ワークショップ用にコピー"
	@echo "make new MOD=名前      新しい Mod を作る"
	@echo "make hooks            コミット前に make check が走るようにする"

check:
	scripts/check.sh

fix:
	scripts/check.sh --fix

build:
	scripts/build.sh $(MOD)

publish:
	scripts/build.sh --publish $(MOD)

pck:
	scripts/export-pck.sh $(MOD)

stage:
	scripts/stage.sh $(MOD)

new:
	scripts/new-mod.sh $(MOD)

hooks:
	git config core.hooksPath .githooks
	@echo "コミット前に scripts/check.sh が走るようになりました"
