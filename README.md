# sts2-mods

**Slay the Spire 2**(Steam AppID `2868840`、Godot/MegaDot + C# 製)向けの Mod をまとめて管理する monorepo です。
初代 Slay the Spire(Java / ModTheSpire / BaseMod、AppID 646570)とは仕組みがまったく違うので、初代向けの情報は参考にしないでください。

## Mod 一覧

| Mod                                                 | 内容                                                                                               |
| --------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| [MapDrawUndo](mods/MapDrawUndo/README.md)           | マップに描いた自分の線を Ctrl+Z(Mac は Cmd+Z も)で 1 本ずつ取り消す。仲間の画面からも消える        |
| [PeerSelectionHud](mods/PeerSelectionHud/README.md) | マルチプレイで、仲間が今いる画面・カーソルを合わせているカード等・マップの投票先を画面左に表示する |
| [MyFirstMod](mods/MyFirstMod)                       | カード・レリック・パワーを追加するサンプル(テンプレートのまま)                                     |

## クイックスタート

ゲームと Steam が入っている PC で行います。詳細は [docs/setup.md](docs/setup.md)、Mac は [docs/setup-mac.md](docs/setup-mac.md)。

1. [.NET SDK 9.0 以上](https://dotnet.microsoft.com/download)、[MegaDot 4.5.1](https://megadot.megacrit.com/)、[Bun](https://bun.sh) を入れる(Mac は `curl -fsSL https://megadot.megacrit.com/install.sh | sh` と `brew install oven-sh/bun/bun`)
2. Steam で [BaseLib](https://steamcommunity.com/sharedfiles/filedetails/?id=3737335127) をサブスクライブ
3. `local.props.example` を `local.props` にコピーし、`GodotPath`(必要なら `Sts2Path`)を書き換える(Mac で既定の場所に入れたなら不要)
4. リポジトリ直下で `bun install`(タスクランナーの [Vite+](https://viteplus.dev) が入り、コミット前の検査も有効になる)
5. ビルドしてゲームに配置する
    ```
    vp run build                       # 全 Mod (= dotnet build sts2-mods.sln)
    vp run build MapDrawUndo           # 1 つだけ
    vp run publish MyFirstMod          # 画像・テキストを変えたとき (.pck も書き出す)
    ```
    `vp` が見つからないときは `bunx vp run build` か、Vite+ を入れる(`curl -fsSL https://vite.plus | bash`)
6. ゲームを起動し「設定 → Mod Settings」に Mod が出れば成功

タスクの一覧は `vp run`(選択画面が出る)か `vite.config.ts` を見てください。

## 開発のルール

警告はすべてエラーです。コミットのたびに `vp run check` が自動で走ります(`bun install` で有効化済み)。
型安全・lint・CI の詳細は [docs/development.md](docs/development.md)。

## ワークショップへの公開

Mega Crit 公式の [sts2-mod-uploader](https://github.com/megacrit/sts2-mod-uploader) を使います。手順は [docs/publishing.md](docs/publishing.md)。

```
vp run publish MapDrawUndo
vp run stage MapDrawUndo
./ModUploader upload -w workshop/MapDrawUndo
```

## 新しい Mod を追加する

`vp run new-mod NewModName`。詳しくは [docs/new-mod.md](docs/new-mod.md)。

## 参考資料

- [Alchyr/ModTemplate-StS2 Wiki](https://github.com/Alchyr/ModTemplate-StS2/wiki)(セットアップ、カード追加、デコンパイル、デバッグ)
- [BaseLib](https://github.com/Alchyr/BaseLib-StS2)
- [megacrit/sts2-mod-uploader](https://github.com/megacrit/sts2-mod-uploader)
- [Slay the Spire 2 Modding Tutorial](https://fresh-milkshake.github.io/Modding-Tutorial/)(マニフェスト、Harmony、.pck、パッケージング)
- [wiki.gg: Modding Tutorials](https://slaythespire.wiki.gg/wiki/Slay_the_Spire_2:Modding_Tutorials)
- 公開デコンパイル [zhiyue/sts2-rl-agent `decompiled/`](https://github.com/zhiyue/sts2-rl-agent/tree/HEAD/decompiled)(ゲームの版が古い可能性あり。自分の sts2.dll を ILSpy 等で見るのが確実)
- [Steam ワークショップ](https://steamcommunity.com/app/2868840/workshop/)
