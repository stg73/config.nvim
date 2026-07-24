local M = {}

local set = vim.keymap.set

-- vimの他のkeybindと機能を揃える
set('i','<cr>','<esc>') -- <cr>で操作を完了・実行する
set('i','<c-c>','<esc>u') -- <c-c>で中断する
set('n','U','<c-r>') -- 大文字にすると逆になる
set("i","<right>","<c-g>U<right>")

function M.bracket(start,finish)
    set("i","<leader>" .. start,start .. finish .. "<c-g>U<left>")
    set({"c","t"},"<leader>" .. start,start .. finish .. "<left>")
end

-- 閉括弧の自動入力
local brackets = {
    "{}",
    "[]",
    "<>",
    "()",
    "''",
    '""',
    -- 日本語
    "「」",
    "『』",
    "【】",
}

function M.setup()
    require("keymaps.char").setup()
    require("keymaps.convenient").setup()

    vim.tbl_map(function(str)
        local s,e = require("regex").find(".")(str)
        M.bracket(string.sub(str,s,e),string.sub(str,e + 1))
    end,brackets)

    set('i','<c-b>','()<c-g>U<left>') set({'c','t'},'<c-b>','()<left>') -- Bracket
    set('i','<c-d>','""<c-g>U<left>') set({'c','t'},'<c-d>','"<left>"') -- Double quote
end

return M
