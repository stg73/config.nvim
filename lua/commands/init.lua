local M = {}

function M.setup()
require("commands.others").setup()

-- 文字をまとめて置換
local s = require("substitute_command")
local c = require("character_table")

s.create("Katakana")(c.Hiragana_Katakana)
s.create_reverse("Hiragana")(c.Hiragana_Katakana)
s.create("Zennkaku")(c.Hannkaku_Zennkaku)
s.create_reverse("Hannkaku")(c.Hannkaku_Zennkaku)
s.create("Dakuonn")(c.Seionn_Dakuonn)
s.create_reverse("Seionn")(c.Seionn_Dakuonn)
s.create("Hutosenn")(c.Hososenn_Hutosenn)
s.create_reverse("Hososenn")(c.Hososenn_Hutosenn)
s.create("Nijuusenn")(c.Itijuusenn_Nijuusenn)
s.create_reverse("Itijuusenn")(c.Itijuusenn_Nijuusenn)
s.create("Kadomaru")(c.Kadokaku_Kadomaru)
s.create_reverse("Kadokaku")(c.Kadokaku_Kadomaru)

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
vim.api.nvim_create_user_command("Pipe",function(x)
    vim.cmd(require("regex").gsub(x.line1 .. "," .. x.line2)("/%")(x.args))
end,
{range = true,nargs = 1,complete = "command"})
end

return M
