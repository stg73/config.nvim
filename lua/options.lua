local M = {}

local o = vim.opt

function M.setup()
-- 無効化
o.mouse = "" -- クリックに反応すると邪魔
o.swapfile = false

o.history = 1000 -- 10000も必要ないし読み込みに時間がかかる

o.autochdir = true
o.fileformats = {"unix","dos"}
o.fileencodings = {
    "utf-8",
    "euc-jp", -- "SKK-JISYO.*"系
    "utf-16le", -- corvusskkの辞書ファイル
    "cp932",
    "ansi",
}

-- 文字
o.autoindent = true
o.list = true
o.listchars = { precedes = "(", extends = ")", trail = "_", tab = ">--" }
o.expandtab = true
o.shiftwidth = 4
o.matchpairs:append({ "<:>", "「:」", "『:』", "【:】" })
o.number = true

o.statusline = "%##" -- 空に設定する
o.fillchars = { eob = " ", stl = "─", stlnc = "─", vert = "│" }

o.pumblend = 1
o.numberwidth = 1 -- ファイルの内容をできるだけ多く表示する
o.laststatus = 0 -- 邪魔
o.showmode = false -- モードなど存在しない
o.ruler = false -- 邪魔
o.cmdwinheight = 10
o.guicursor = { "n-v-sm:block", "i-c-t-ci-o-ve:ver25", "r-cr:hor20" }
o.showtabline = 0

local set_shell_options = function()
    fp.items(function(opt,val)
        vim.o[opt] = val
    end)(require("shell").options(vim.o.shell))
end
vim.api.nvim_create_autocmd("OptionSet",{
    pattern = "shell",
    group = vim.api.nvim_create_augroup("shell"),
    desc = "shell* 系オプションを 'shell' の値に合わせて設定する",
    callback = set_shell_options,
})

o.shell = "nu"
set_shell_options()

o.warn = false
o.completeslash = "slash" -- スラッシュのほうが扱いやすい

-- 検索・置換
o.wrapscan = false -- 終わりを知りたい
o.gdefault = true -- 既定で行のすべてを置換する

o.timeout = false -- キーマップを楽に使う
end

return M
