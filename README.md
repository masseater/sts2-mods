# sts2-mods

**Slay the Spire 2**(Steam AppID `2868840`、Godot/MegaDot + C# 製)向けの Mod を作るリポジトリです。
初代 Slay the Spire(Java / ModTheSpire / BaseMod、AppID 646570)とは仕組みがまったく違うので、初代向けの情報は参考にしないでください。

## 構成

```
sts2-mods/
  mods/
    MyFirstMod/            Mod プロジェクト (Alchyr.Sts2.Templates 2.5.2 の Content テンプレートから生成)
      MyFirstMod.sln       Godot は .slnx ではなく .sln が必要
      MyFirstMod.csproj    sts2.dll / BaseLib / ModAnalyzers を参照。ビルド時にゲームの mods フォルダへ自動コピー
      MyFirstMod.json      Mod マニフェスト (id は変えない)
      MyFirstModCode/      C# コード。MainFile.cs が初期化、Cards/Relics/Powers に基底クラス
      MyFirstMod/          .pck に入るアセット (images/、localization/eng/*.json)
  workshop/
    MyFirstMod/            公式アップローダ用ワークスペース (workshop.json, image.png, content/)
  scripts/
    stage.ps1              Publish 済みファイルをワークスペースの content/ にコピー (Windows)
    stage.sh               同上 (Mac / Linux)
  docs/                    セットアップ・公開手順・新しい Mod の追加方法
  local.props.example      PC ごとのパス設定の見本 (local.props にコピーして使う)
```

## クイックスタート

ゲームと Steam が入っている PC で行います。詳細は [docs/setup.md](docs/setup.md)、Mac は [docs/setup-mac.md](docs/setup-mac.md)。

1. [.NET SDK 9.0 以上](https://dotnet.microsoft.com/download) と [MegaDot 4.5.1](https://megadot.megacrit.com/) を入れる(Mac は `curl -fsSL https://megadot.megacrit.com/install.sh | sh`)
2. Steam で [BaseLib](https://steamcommunity.com/sharedfiles/filedetails/?id=3737335127) をサブスクライブ
3. `local.props.example` を `local.props` にコピーし、`GodotPath`(必要なら `Sts2Path`)を書き換える(Mac で既定の場所に入れたなら不要)
4. ビルドしてゲームに配置する
   ```
   cd mods/MyFirstMod
   dotnet build     # C# だけ変えたとき (.dll をコピー)
   dotnet publish   # 画像・テキスト・シーンを変えたとき (.pck も書き出す)
   ```
5. ゲームを起動し「設定 → Mod Settings」に MyFirstMod が出れば成功

## ワークショップへの公開

Mega Crit 公式の [sts2-mod-uploader](https://github.com/megacrit/sts2-mod-uploader) を使います。手順は [docs/publishing.md](docs/publishing.md)。

```
dotnet publish                                   # mods/MyFirstMod で
.\scripts\stage.ps1 -ModName MyFirstMod          # リポジトリ直下で
ModUploader.exe upload -w workshop\MyFirstMod

# Mac / Linux
scripts/stage.sh MyFirstMod
./ModUploader upload -w workshop/MyFirstMod
```

## 新しい Mod を追加する

[docs/new-mod.md](docs/new-mod.md) を参照。

## 参考資料

- [Alchyr/ModTemplate-StS2 Wiki](https://github.com/Alchyr/ModTemplate-StS2/wiki)(セットアップ、カード追加、デコンパイル、デバッグ)
- [BaseLib](https://github.com/Alchyr/BaseLib-StS2)
- [megacrit/sts2-mod-uploader](https://github.com/megacrit/sts2-mod-uploader)
- [Slay the Spire 2 Modding Tutorial](https://fresh-milkshake.github.io/Modding-Tutorial/)(マニフェスト、Harmony、.pck、パッケージング)
- [wiki.gg: Modding Tutorials](https://slaythespire.wiki.gg/wiki/Slay_the_Spire_2:Modding_Tutorials)
- [Steam ワークショップ](https://steamcommunity.com/app/2868840/workshop/)
