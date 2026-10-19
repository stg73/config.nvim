neovimのconfig
neovimのバージョンは nightly v0.13 4b5dcbccd7
サブpcでは release v0.12 を使っている。

ディレクトリ構造
├── lua/
│   ├── excmds.lua
│   ├── excmds/
│   │   ├─── nu.lua -- nu を編集する用
│   │   ╰─── help.lua -- vim help の編集用
│   │
│   ├── keymaps.lua
│   ├── env.lua -- 環境変数
│   ├── highlights.lua -- set_hl
│   ├── nvim.lua -- vim.api.nvim_* を nvim.* としてアクセスできるようにする
│   ├── options.lua -- オプションの設定
│   ├── options/
│   │   ╰─── shell.lua -- シェル毎のオプション
│   ├── packages.lua -- プラグインの読み込みと設定
│   ├── shell.lua -- シェル毎のオプション
│   ├── terminal_multiplexer.lua -- Nvimをターミナルマルチプレクサとして使う。タイリングウィンドウマネージャがない場合用
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
├── install-nvim-dev.nu -- nvimの開発版をインストールする
╰── readme.txt
