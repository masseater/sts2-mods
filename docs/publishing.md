# Steam ワークショップへの公開

Mega Crit 公式の [sts2-mod-uploader](https://github.com/megacrit/sts2-mod-uploader)(Steamworks を使うコマンドラインツール)でアップロードします。Steam を起動してログインした状態で行ってください。

## 準備(初回のみ)

1. sts2-mod-uploader を取得する(リリースの `ModUploader-<OS>.zip`。`win-x64` / `osx-arm64` / `osx-x64` / `linux-x64` がある。またはソースを clone して `dotnet publish -c Release -r <OS>`)
2. `workshop/<ModName>/workshop.json` を編集する(各項目の意味は [workshop-json-reference.md](workshop-json-reference.md))
    - `title` / `description` / `tags`
    - `dependencies`: 依存するワークショップアイテムの ID を数値で書く(`[3737335127]`。`["3737335127"]` と文字列にするとアップローダが "Exception thrown while parsing the workshop config!" で止まる)。BaseLib は設定済み
    - `visibility`: 最初は `"private"` のままにしておく
3. `workshop/<ModName>/image.png` を自作のサムネイル(1MB 未満)に差し替える

## アップロード

```
cd mods/MyFirstMod
dotnet publish                                  # 最新の json / dll / pck をゲームの mods フォルダへ
cd ../..
.\scripts\stage.ps1 -ModName MyFirstMod         # workshop/MyFirstMod/content/MyFirstMod/ にコピー
<アップローダの場所>\ModUploader.exe upload -w workshop\MyFirstMod
```

Mac / Linux では `stage.ps1` の代わりに `scripts/stage.sh MyFirstMod`、アップローダは `ModUploader`(`.exe` なし)を使います。Mac の詳細は [setup-mac.md](setup-mac.md#5-ワークショップへのアップロードmac)。

ワークショップには「Mod 名のフォルダごと」上げます(`content/MyFirstMod/MyFirstMod.json` など)。`stage.ps1` / `stage.sh` がその形に揃えます。

初回アップロード後、ワークスペースに `mod_id.txt`(ワークショップ ID)ができます。**これはコミットしてください**。次回以降の更新先になります。

## 公開までの流れ

1. `private` で上げる
2. ローカルの `<ゲーム>/mods/MyFirstMod` を一時的に退避し、Steam でサブスクライブした版だけで動作確認する
3. 問題なければ `workshop.json` の `visibility` を `"public"` にして再アップロード

## 更新

1. `MyFirstMod.json` の `version` を上げる
2. `workshop.json` の `changeNote` に変更点を書く
3. 上の「アップロード」と同じコマンドを実行する

失敗したときはアップローダと同じ場所にできる `mod-uploader.log` を確認します。
