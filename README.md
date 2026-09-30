# sts2-mods

**Slay the Spire 2**(Steam AppID `2868840`、Godot/MegaDot + C# 製)向けの Mod をまとめて管理する monorepo です。
初代 Slay the Spire(Java / ModTheSpire / BaseMod、AppID 646570)とは仕組みがまったく違うので、初代向けの情報は参考にしないでください。

## Mod 一覧

| Mod | 内容 |
| --- | --- |
| [MapDrawUndo](mods/MapDrawUndo/README.md) | マップに描いた自分の線を Ctrl+Z(Mac は Cmd+Z も)で 1 本ずつ取り消す。仲間の画面からも消える |
| [PeerSelectionHud](mods/PeerSelectionHud/README.md) | マルチプレイで、仲間が今いる画面・カーソルを合わせているカード等・マップの投票先を画面左に表示する |
| [MyFirstMod](mods/MyFirstMod) | カード・レリック・パワーを追加するサンプル(テンプレートのまま) |

## 構成

```
sts2-mods/
  sts2-mods.sln              全 Mod を含むソリューション
  Directory.Build.props      全プロジェクト共通の設定 (パス解決、言語設定、警告=エラー、アナライザ)
  Directory.Build.targets    Mod 共通のビルド処理 (sts2.dll / BaseLib の参照、mods フォルダへのコピー、.pck 書き出し)
  .editorconfig              コードスタイル・命名規則・アナライザの強さ
  Makefile                   make check / fix / build / publish / pck / stage / new / hooks
  mods/<Mod>/                Mod プロジェクト。csproj は TargetFramework と Mod 固有の設定だけ
    <Mod>.csproj
    <Mod>.json               Mod マニフェスト
    <Mod>Code/               C# コード
    <Mod>/                   .pck に入るアセット (画像・ローカライズ。無い Mod もある)
    project.godot, export_presets.cfg   .pck 書き出し用
  shared/                    全 Mod に取り込む共通コード (ソースとして各 dll に入る)
  build/
    Sts2PathDiscovery.props  ゲームの場所を OS ごとに自動検出
    Sts2Stubs/               sts2.dll の型を真似たスタブ。ゲームが無い CI での型チェック用
  templates/mod/             scripts/new-mod.sh が使う雛形
  workshop/<Mod>/            公式アップローダ用ワークスペース (workshop.json, image.png, content/)
  scripts/                   build / check / export-pck / new-mod / stage
  docs/                      セットアップ・開発・公開の手順
  local.props.example        PC ごとのパス設定の見本 (local.props にコピーして使う)
```

## クイックスタート

ゲームと Steam が入っている PC で行います。詳細は [docs/setup.md](docs/setup.md)、Mac は [docs/setup-mac.md](docs/setup-mac.md)。

1. [.NET SDK 9.0 以上](https://dotnet.microsoft.com/download) と [MegaDot 4.5.1](https://megadot.megacrit.com/) を入れる(Mac は `curl -fsSL https://megadot.megacrit.com/install.sh | sh`)
2. Steam で [BaseLib](https://steamcommunity.com/sharedfiles/filedetails/?id=3737335127) をサブスクライブ
3. `local.props.example` を `local.props` にコピーし、`GodotPath`(必要なら `Sts2Path`)を書き換える(Mac で既定の場所に入れたなら不要)
4. ビルドしてゲームに配置する
   ```
   make build                  # 全 Mod (= dotnet build sts2-mods.sln)
   make build MOD=MapDrawUndo  # 1 つだけ
   make publish MOD=MyFirstMod # 画像・テキストを変えたとき (.pck も書き出す)
   ```
5. ゲームを起動し「設定 → Mod Settings」に Mod が出れば成功

## 開発のルール

警告はすべてエラーです。コミット前に `make check` を通してください(`make hooks` で自動化)。
型安全・lint・CI の詳細は [docs/development.md](docs/development.md)。

## ワークショップへの公開

Mega Crit 公式の [sts2-mod-uploader](https://github.com/megacrit/sts2-mod-uploader) を使います。手順は [docs/publishing.md](docs/publishing.md)。

```
make publish MOD=MapDrawUndo
make stage MOD=MapDrawUndo
./ModUploader upload -w workshop/MapDrawUndo
```

## 新しい Mod を追加する

`make new MOD=NewModName`。詳しくは [docs/new-mod.md](docs/new-mod.md)。

## 参考資料

- [Alchyr/ModTemplate-StS2 Wiki](https://github.com/Alchyr/ModTemplate-StS2/wiki)(セットアップ、カード追加、デコンパイル、デバッグ)
- [BaseLib](https://github.com/Alchyr/BaseLib-StS2)
- [megacrit/sts2-mod-uploader](https://github.com/megacrit/sts2-mod-uploader)
- [Slay the Spire 2 Modding Tutorial](https://fresh-milkshake.github.io/Modding-Tutorial/)(マニフェスト、Harmony、.pck、パッケージング)
- [wiki.gg: Modding Tutorials](https://slaythespire.wiki.gg/wiki/Slay_the_Spire_2:Modding_Tutorials)
- 公開デコンパイル [zhiyue/sts2-rl-agent `decompiled/`](https://github.com/zhiyue/sts2-rl-agent/tree/HEAD/decompiled)(ゲームの版が古い可能性あり。自分の sts2.dll を ILSpy 等で見るのが確実)
- [Steam ワークショップ](https://steamcommunity.com/app/2868840/workshop/)
