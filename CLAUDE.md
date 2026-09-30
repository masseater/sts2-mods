# sts2-mods

Slay the Spire 2 (AppID 2868840, Godot/MegaDot 4.5.1 + C# net9.0) の Mod リポジトリ。初代 Slay the Spire (Java/ModTheSpire) の知識は使わないこと。

- Mod プロジェクトは `mods/<ModName>/`、ワークショップ用ワークスペースは `workshop/<ModName>/`
- 各 Mod は Alchyr.Sts2.Templates + BaseLib ベース。パスは repo 直下の `local.props`(gitignore)から読む
- ビルドにはゲーム本体の `sts2.dll` が必要なので、ゲームの無い環境では `dotnet build` は "Slay the Spire 2 data not found" で止まる(想定どおり)
- ドキュメントとコメントは日本語で書く
