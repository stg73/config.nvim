local M = {}

function M.setup()
require("commands.others").setup()

-- help を編集するためのコマンド
vim.api.nvim_create_user_command("H",function()
    require("commands.help").translate({
        dir = vim.env.VIMRUNTIME .. "/doc",
        name = vim.fn.expand("%:r")
    })
end,{})

-- nu を編集するためのコマンド
vim.api.nvim_create_user_command("NuExternCommand",function(x) require("commands.nu").extern_command(x) end,{ nargs = "*", range = true })
vim.api.nvim_create_user_command("NuExternFlag",function(x) require("commands.nu").extern_flag(x) end,{ range = true })

-- 文字をまとめて置換
local s = require("substitute_command")
local c = require("character_table")

local tbl = require("tbl")
tbl.pairs(function(k_v)
    require("substitute_command").create_command(k_v[1])(k_v[2])
end)({
    Katakana = c.Hiragana_Katakana,
    Hiragana = tbl.pairs(tbl.reverse)(c.Hiragana_Katakana),
    Zennkaku = c.Hannkaku_Zennkaku,
    Hannkaku = tbl.pairs(tbl.reverse)(c.Hannkaku_Zennkaku),
    Dakuonn = c.Seionn_Dakuonn,
    Seionn = tbl.pairs(tbl.reverse)(c.Seionn_Dakuonn),
    Hutosenn = c.Hososenn_Hutosenn,
    Hososenn = tbl.pairs(tbl.reverse)(c.Hososenn_Hutosenn),
    Nijuusenn = c.Itijuusenn_Nijuusenn,
    Itijuusenn = tbl.pairs(tbl.reverse)(c.Itijuusenn_Nijuusenn),
    Kadomaru = c.Kadokaku_Kadomaru,
    Kadokaku = tbl.pairs(tbl.reverse)(c.Kadokaku_Kadomaru),
})

-- SKK辞書を編集する
local k = require("skk").command

vim.api.nvim_create_user_command("SkkSort", k.sort,
{bar = true,range = true})

-- 最重要
vim.api.nvim_create_user_command("SkkAnnotate", k.annotate,
{bar = true,range = "%"})

vim.api.nvim_create_user_command("SkkCountAnnotationErrors", k.count_annotation_errors,
{bar = true,range = "%"})

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
