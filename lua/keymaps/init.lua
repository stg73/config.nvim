local set = vim.keymap.set

-- vimの他のkeybindと機能を揃える
set('i','<c-c>','<esc>u') -- <c-c>で中断する
set('n','U','<c-r>') -- 大文字にすると逆になる
set("i","<right>","<c-g>U<right>")

local function bracket(start,finish)
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

require("keymaps.convenient").setup()

vim.tbl_map(function(str)
    local s,e = require("regex").find(".")(str)
    bracket(string.sub(str,s,e),string.sub(str,e + 1))
end,brackets)

fp.items(function(k,start)
    set({"i","c","t"},k,"<leader>" .. start,{ remap = true })
end) {
    ["<c-b>"] = "(", -- Bracket
    ["<c-d>"] = '"', -- Double quote
}
