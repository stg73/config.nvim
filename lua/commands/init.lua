local M = {}

function M.setup()
vim.api.nvim_create_user_command('Normal','<line1>,<line2>g/^/execute "normal <args>" | nohlsearch',{range = true,bar = true,nargs = 1}) -- normalのラッパー エスケープで制御文字が使える rangeが指定できる パイプが使える
vim.api.nvim_create_user_command('Todo','split ~/memos/todo.txt | set nobuflisted',{bar = true})

-- help を編集するためのコマンド
vim.api.nvim_create_user_command("H",function(opts)
    require("commands.help").translate({
        dir = (opts.args ~= "") and opts.args or (vim.env.t .. "/neovim/runtime"),
        name = vim.fn.expand("%:r")
    })
end,{ nargs = "*", complete = "file" })

-- nu を編集するためのコマンド
vim.api.nvim_create_user_command("NuExternCommand",function(x) require("commands.nu").extern_command(x) end,{ nargs = "*", range = true })
vim.api.nvim_create_user_command("NuExternFlag",function(x) require("commands.nu").extern_flag(x) end,{ range = true })

-- 文字をまとめて置換
local s = require("substitute_cmd")
local c = require("char_map")

local fp = require("fp")
fp.pairs(function(k_v)
    s.create_cmd(k_v[1])(k_v[2])
end)({
    Katakana = c.Hiragana_Katakana,
    Hiragana = fp.pairs(fp.reverse)(c.Hiragana_Katakana),
    Zennkaku = c.Hannkaku_Zennkaku,
    Hannkaku = fp.pairs(fp.reverse)(c.Hannkaku_Zennkaku),
    Dakuonn = c.Seionn_Dakuonn,
    Seionn = fp.pairs(fp.reverse)(c.Seionn_Dakuonn),
    Hutosenn = c.Hososenn_Hutosenn,
    Hososenn = fp.pairs(fp.reverse)(c.Hososenn_Hutosenn),
    Nijuusenn = c.Itijuusenn_Nijuusenn,
    Itijuusenn = fp.pairs(fp.reverse)(c.Itijuusenn_Nijuusenn),
    Kadomaru = c.Kadokaku_Kadomaru,
    Kadokaku = fp.pairs(fp.reverse)(c.Kadokaku_Kadomaru),
})

-- SKK辞書を編集する
local k = require("skk").cmd

vim.api.nvim_create_user_command("SkkSort", k.sort,
{bar = true,range = true})

-- 最重要
vim.api.nvim_create_user_command("SkkAnnotate", k.annotate,
{bar = true,range = "%",nargs="*"})

vim.api.nvim_create_user_command("SkkCountAnnotationErrors", k.count_annotation_errors,
{bar = true,range = "%",nargs="*"})

vim.api.nvim_create_user_command("SkkSearchAnnotationErrors", k.search_annotation_errors,
{bar = true})

vim.api.nvim_create_user_command("SkkSearchMidasiKouho", k.search_midasi_kouho,
{bar = true})

-- 指定した範囲に対し複数のコマンドを実行
-- Pipe の後に書いたコマンド中の "%" がPipeの範囲に置換される
-- 例: "'<,'>Pipe %w hoge | %d" -> "'<,'>w hoge | '<,'>d"
vim.api.nvim_create_user_command("Pipe",function(x)
    local range = x.line1 .. "," .. x.line2
    vim.cmd(require("regex").gsub(range)("\\%")(x.args))
end,{
    range = true,
    nargs = 1,
    complete = "command",
})

-- luaモジュールのキャッシュを削除する
-- 第2引数を指定するとそのグローバル変数に require 結果を代入する
vim.api.nvim_create_user_command("DelCach",function(x)
    local mod = x.fargs[1]
    local var = x.fargs[2]
    if package.loaded[mod] == nil then
        vim.notify("そんな物はない",vim.log.levels.WARN)
    end
    package.loaded[mod] = nil
    if var then
        _G[var] = require(mod)
    end
end,{
    nargs = "*",
    complete = function()
        return vim.fn.sort(vim.tbl_keys(package.loaded))
    end,
})
end

return M
