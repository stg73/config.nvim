local M = {}

local set = vim.keymap.set

function M.bracket(b_start,b_end)
    set("i",b_start,b_start .. b_end .. "<c-g>U<left>")
    set({"c","t"},b_start,b_start .. b_end .. "<left>")
    set({"i","c","t"},"<leader>" .. b_start,b_start)
end

require("keymaps.char")
require("keymaps.keyboard")
require("keymaps.convenient")
require("keymaps.hoge")

-- 閉括弧の自動入力
local brackets = {
    {"{","}"},
    {"[","]"},
    {"<",">"},
    -- 日本語
    {"「","」"},
    {"『","』"},
    {"【","】"},
}

vim.tbl_map(function(t)
    M.bracket(t[1],t[2])
end,brackets)

set('i','<c-b>','()<c-g>U<left>') set({'c','t'},'<c-b>','()<left>') -- Bracket
set('i','<c-d>','""<c-g>U<left>') set({'c','t'},'<c-d>','"<left>"') -- Double quote

return M
