# 新しい Mod を追加する

1 つのリポジトリで複数の Mod を管理できます。

```
dotnet new install Alchyr.Sts2.Templates              # 初回のみ
cd mods
dotnet new alchyrsts2contentmod --ModAuthor masseater -o NewModName
cd NewModName
dotnet new sln -n NewModName --format sln
dotnet sln NewModName.sln add NewModName.csproj
```

- テンプレート: `alchyrsts2contentmod`(カード・レリック・ポーション)、`alchyrsts2charmod`(新キャラクター)、`alchyrsts2mod`(最小構成)
- Mod 名にスペースとアンダースコアは使えない

生成後に次の調整をします。

1. `NewModName/.gitignore` と `.gitattributes` を削除する(リポジトリ直下のものを使う)
2. `NewModName/Directory.Build.props` を `mods/MyFirstMod/Directory.Build.props` と同じ内容にする(`local.props` を読むため)
3. `export_presets.cfg` の `exclude_filter` がテンプレート名のままなら `NewModName.json` に直す
4. `workshop/MyFirstMod` をコピーして `workshop/NewModName` を作り、`workshop.json` と `image.png` を書き換える(`mod_id.txt` はコピーしない)
