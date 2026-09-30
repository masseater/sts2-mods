import { defineConfig } from "vite-plus";

// タスクは `vp run <名前>` で実行する。引数は `vp run build MapDrawUndo` のようにそのまま後ろに付ける
export default defineConfig({
    run: {
        tasks: {
            // 整形・型チェック・アナライザ・マニフェスト検査。コミット前 (.vite-hooks/pre-commit) と CI も同じ。
            // vp check は C# 以外 (md / json / ts) の整形、scripts/check.sh は C# と Mod 固有の検査
            check: { cache: false, command: "vp check && scripts/check.sh" },
            // 整形とコードスタイルを自動で直してから検査
            fix: { cache: false, command: "vp check --fix && scripts/check.sh --fix" },
            // ビルドしてゲームの mods フォルダへ配置 (引数なしで全 Mod)
            build: { cache: false, command: "scripts/build.sh" },
            // .pck も書き出して配置
            publish: { cache: false, command: "scripts/build.sh --publish" },
            // .pck だけ書き出す (ゲーム不要)
            pck: { cache: false, command: "scripts/export-pck.sh" },
            // ワークショップ用ワークスペースへコピー
            stage: { cache: false, command: "scripts/stage.sh" },
            // 新しい Mod を作る
            "new-mod": { cache: false, command: "scripts/new-mod.sh" },
        },
    },
});
