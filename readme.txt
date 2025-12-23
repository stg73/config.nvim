neovimのconfig
neovimのバージョンは0.12.0

ディレクトリ構造
├── lua/
│   ├── commands/ -- Exコマンド
│   │   ├─── init.lua -- いろいろ
│   │   ├─── others.lua
│   │   ╰─── terminal.lua -- ターミナルバッファで使うもの
│   │
│   ├── keymaps/ -- キーマップ
│   │   ├─── bracket.lua -- 閉括弧の自動入力のようなもの
│   │   ├─── char.lua -- 本来キーボードでやるべきこと
│   │   ├─── convenient.lua -- 便利なもの
│   │   ├─── hoge.lua -- 名前を思い付かなかった
│   │   ├─── init.lua
│   │   ╰─── keyboard.lua
│   │
│   ├── env.lua -- 環境変数
│   ├── highlights.lua -- set_hl
│   ├── options.lua -- オプション
│   ╰── packages.lua -- プラグインの読み込みと設定
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
