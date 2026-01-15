local M = {}

local set = vim.keymap.set

function M.bracket(b_start,b_end)
    set("i",b_start,b_start .. b_end .. "<c-g>U<left>")
    set({"c","t"},b_start,b_start .. b_end .. "<left>")
    set({"i","c","t"},"<leader>" .. b_start,b_start)
end

-- 閉括弧の自動入力
local brackets = {
    "{}",
    "[]",
    "<>",
    -- 日本語
    "「」",
    "『』",
    "【】",
}

function M.setup()
    require("keymaps.char").setup()
    require("keymaps.convenient").setup()
    require("keymaps.hoge").setup()

    vim.tbl_map(function(str)
        local s,e = require("regex").find(".")(str)
        M.bracket(string.sub(str,s,e),string.sub(str,e + 1))
    end,brackets)

    set('i','<c-b>','()<c-g>U<left>') set({'c','t'},'<c-b>','()<left>') -- Bracket
    set('i','<c-d>','""<c-g>U<left>') set({'c','t'},'<c-d>','"<left>"') -- Double quote
end

return M
