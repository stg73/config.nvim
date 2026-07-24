neovimのconfig
neovimのバージョンは nightly 69e1321731

ディレクトリ構造
├── lua/
│   ├── commands/ -- Exコマンド
│   │   ├─── init.lua
│   │   ├─── nu.lua -- nu を編集する用
│   │   ╰─── help.lua -- vim help の編集用
│   │
│   ├── keymaps/ -- キーマップ
│   │   ├─── char.lua -- 本来キーボードでやるべきこと
│   │   ├─── convenient.lua -- 便利なもの
│   │   ├─── hoge.lua -- その他
│   │   ╰─── init.lua
│   │
│   ├── env.lua -- 環境変数
│   ├── highlights.lua -- set_hl
│   ├── nvim.lua -- vim.api のラッパー
│   ├── options.lua -- オプションの設定
│   ├── packages.lua -- プラグインの読み込みと設定
│   ├── shell.lua -- シェル毎のオプション
│   ╰── ui2.lua -- ui2の設定
│
├── syntax/ -- 標準のハイライトを少し修正
│   ├── css.lua
│   ├── gitcommit.lua -- 接頭辞に対応
│   ├── html.lua
│   ├── nu.lua
│   ├── ps1.lua
│   ├── text.lua
│   ╰── xml.lua
│
├── filetype.lua
├── init.lua
╰── readme.txt
