local set = vim.keymap.set

set({"i","v","t","o"},"\t","<cmd>set noexpandtab<cr><cmd>set shiftwidth=8<cr>\t<cmd>set expandtab<cr><cmd>set shiftwidth=4<cr>")
set("i","<leader>r","<cr>") -- Return
set({"i","t","c"},"<c-q>","'") -- Quote scheme用

local keys = {
    ["<esc>"] = '', -- 以下を不自由なく使うために必要
    i = "#", -- Igeta 井桁
    p = "%", -- Percent sign
    k = "*", -- asterisK
    c = "^", -- Circumflex
    t = "~", -- Tilde
    a = "&", -- Ampersand
    d = "$", -- Dollar mark
    v = "|", -- Vertical bar
    x = "!", -- EXclamation mark
    q = "?", -- Question mark
    ["-"] = "-", -- -
    h = "/", -- slasH
    b = "\\", -- Back slash
    u = "_", -- Under bar
    [";"] = ":", -- 形が:に似ている

    -- nuMber 大西配列のホーム行の順番
    me = "0",
    mi = "1",
    ma = "2",
    mo = "3",
    ["m-"] = "4",
    mk = "5",
    mt = "6",
    mn = "7",
    ms = "8",
    mh = "9",
}

local function keybord(x,y)
    set({"n","i","v","c","t","o"},"<leader>" .. x,y,{ remap = true })
end

vim.tbl_map(function(key)
    keybord(key,keys[key])
end,vim.tbl_keys(keys))
