# 開発のルール (型安全・lint・CI)

## まとめ

- 警告はすべてエラー(`TreatWarningsAsErrors`)。`#pragma warning disable` ではなく、どうしても必要なときだけ `[SuppressMessage(..., Justification = "理由")]` を付ける
- 検査は `vp run check`。`bun install` 後はコミットのたびに自動で走る(`.vite-hooks/pre-commit`。急ぎのときは `git commit --no-verify`。CI で同じ検査が走る)
- 整形とコードスタイルの自動修正は `vp run fix`
- タスクは [Vite+](https://viteplus.dev) の `vp run` で実行する。定義は `vite.config.ts`、中身は `scripts/` のシェルスクリプト
- Claude Code で作業するときは [cc-jev-teacher](https://github.com/masseater/cc-jev-teacher) プラグインが有効になる(`.claude/settings.json`)。TypeSafe の API キーは各自の Claude Code に登録し、リポジトリには置かない

## 何を検査しているか

| 検査                                                                                              | 中身                                                                                                       | 設定の場所                                |
| ------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------- | ----------------------------------------- |
| 言語                                                                                              | `Nullable` 有効、`LangVersion latest`、`Features=strict`                                                   | `Directory.Build.props`                   |
| .NET 標準アナライザ                                                                               | `AnalysisLevel = latest-all`(CA ルールをすべて有効)                                                        | `Directory.Build.props` / `.editorconfig` |
| コードスタイル                                                                                    | 命名規則・`{}` 必須・file-scoped namespace・不要な using など。ビルド時にも検査(`EnforceCodeStyleInBuild`) | `.editorconfig`                           |
| [Meziantou.Analyzer](https://github.com/meziantou/Meziantou.Analyzer)                             | 文字列比較の明示、1 ファイル 1 型など                                                                      | `.editorconfig`                           |
| [MicroUtils.HarmonyAnalyzers](https://github.com/microsoftenator2022/MicroUtils.HarmonyAnalyzers) | Harmony パッチの対象メソッドが実在するか、引数名・型・`__instance` の型が合っているか                      | —                                         |
| Alchyr.Sts2.ModAnalyzers                                                                          | カード等のローカライズ漏れ(アセットを持つ Mod だけ)                                                        | —                                         |
| マニフェスト                                                                                      | `id` とフォルダ名、`has_pck` とアセットフォルダの有無、`workshop.json` の依存の書き方                      | `scripts/check.sh`                        |
| シェルスクリプト                                                                                  | shellcheck                                                                                                 | `scripts/check.sh`                        |
| C# 以外 (md / json / yml / ts)                                                                    | Vite+ の整形 (oxfmt) と lint (oxlint)                                                                      | `vite.config.ts`                          |

Godot のノードは `IDisposable` ですが寿命はシーンツリーが管理するので、Dispose を求める CA1001 / CA2000 / CA2213 は切っています。
`MyFirstMod`(テンプレートのままのサンプル)だけは警告をエラーにせず、アナライザも推奨レベルにしています。

## ゲームが無い環境での型チェック (スタブ)

C# のビルドにはゲーム本体の `sts2.dll` が要りますが、CI やクラウドにはありません。
そこで `build/Sts2Stubs/` に、Mod が使うゲームの型だけを同じ名前空間・シグネチャで書いた「スタブ」(中身は `throw null!`)を置き、
`-p:UseSts2Stubs=true` のときは本物の代わりにこれを参照してコンパイルします。これで CI でも型エラーとアナライザを検出できます。

- スタブは公開デコンパイル([zhiyue/sts2-rl-agent](https://github.com/zhiyue/sts2-rl-agent/tree/HEAD/decompiled))から書き写したもの。ゲームの更新でずれることがあるので、**本当の検証はゲームのある PC での `vp run check`**(こちらは本物の `sts2.dll` でビルドする)
- Mod でゲームの型やメンバーを新しく使ったら、スタブにも同じシグネチャで足す
- スタブでビルドした dll は配らない(mods フォルダへのコピーもしない)

## Harmony パッチの書き方

名前を文字列で書くと、打ち間違いやゲーム側の変更に実行時まで気づけません。次のように書きます。

```csharp
// csproj で <Publicize>true</Publicize> にすると private メンバーもコンパイル時は public に見える (Krafs.Publicizer)
[HarmonyPatch(typeof(NMapDrawings), nameof(NMapDrawings.HandleDrawingMessage))]  // 文字列ではなく nameof
internal static class HandleDrawingMessagePatch
{
    // 引数名は元のメソッドと同じにする (Harmony は名前で渡す)。違うと HarmonyAnalyzers がエラーにする
    internal static void Postfix(NMapDrawings __instance, ulong senderId) { ... }
}
```

- `AccessTools.Field(typeof(X), "name")` のようなリフレクションは使わず、`Publicize` で直接アクセスする
- パッチは Mod ごとに `Patches` クラスの入れ子にまとめる(`Harmony.PatchAll` は入れ子の型も探す)
- ネットワークメッセージ(`INetMessage`)の型名は `z` で始める。ゲームはメッセージ型を型名順に並べて ID を振るので、
  名前順の最後に置かないと、その Mod を入れていない相手と ID がずれる

## CI (GitHub Actions)

`.github/workflows/ci.yml`。ゲームが無いのでできる範囲だけです。

| ジョブ                       | 中身                                                                                                                                                   |
| ---------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| 整形・型チェック・アナライザ | `vp run check`(Vite+ の整形・lint、restore、`dotnet format --verify-no-changes`、スタブでの `dotnet build`(警告=エラー)、マニフェスト検査、shellcheck) |
| .pck 書き出し                | Linux 版 MegaDot でアセットを持つ Mod の .pck を書き出し、成果物として保存                                                                             |

本物の `sts2.dll` でのビルドとゲームでの動作確認は、ゲームのある PC で行います。
