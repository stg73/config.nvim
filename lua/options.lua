local M = {}

local o = vim.opt

function M.setup()
-- 無効化
o.mouse = ""
o.swapfile = false

o.autochdir = true
o.fileencodings = {
    "utf-8",
    "euc-jp", -- "SKK-JISYO.*"系
    "utf-16le", -- corvusskkの辞書ファイル
    "cp932",
    "ansi"
}
o.fileencoding = "utf-8"

-- 文字
o.autoindent = true
o.list = true
o.listchars = { precedes = "(", extends = ")", space = "_", tab = ">--" }
o.expandtab = true
o.shiftwidth = 4
o.matchpairs:append({ "<:>", "「:」", "『:』", "【:】" })
o.number = true

o.pumblend = 1
o.statusline = "─"
o.fillchars = { eob = " ", stl = "─", stlnc = "─", vert = "│" }
o.numberwidth = 1 -- ファイルの内容をできるだけ多く表示する
o.laststatus = 0 -- 邪魔
o.showmode = false -- モードなど存在しない
o.ruler = false -- 表示はできるだけ少なく
o.cmdwinheight = 10
o.guicursor = { "n-v-sm:block", "i-c-t-ci-o-ve:ver25", "r-cr:hor20" }

o.shellcmdflag = "--login --no-newline --stdin --commands" -- 設定を読み込む 余計な行を表示しない ":%!ls" などが使えるように
o.shellxquote = "" -- よくわからない
o.shell = "nu.exe" -- 拡張子が無いとバッファ名の拡張子が大文字になって気持ち悪い
o.warn = false -- 未保存バッファで外部コマンドを実行しても注意を出さない
o.shellslash = true -- スラッシュのほうが扱いやすい

-- 検索・置換
o.wrapscan = false -- 終わりを知りたい
o.magic = false -- 正規表現が使いたきゃ\vを使うから邪魔なだけ
o.gdefault = true -- 既定で行のすべてを置換する

o.timeout = false -- キーマップを楽に使う
o.ttimeout = false -- powershellでエスケープを長押ししたときにエスケープがプロンプトに入力されないようになる
end

return M
