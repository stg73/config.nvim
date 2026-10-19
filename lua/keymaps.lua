local M = {}

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

local r = require("regex")

vim.tbl_map(function(str)
    local s,e = r.find(".")(str)
    bracket(string.sub(str,s,e),string.sub(str,e + 1))
end,brackets)

fp.items(function(k,start)
    set({"i","c","t"},k,"<leader>" .. start,{ remap = true })
end) {
    ["<c-b>"] = "(", -- Bracket
    ["<c-d>"] = '"', -- Double quote
}

-- 検索系
local search = function(str)
    return vim.ui.open("https://google.com/search?q=" .. vim.uri_encode(str))
end

local get_region = function(s,e)
    local mode = vim.fn.visualmode()
    return table.concat(vim.fn.getregion(s,e,{ type = mode ~= "" and mode or "v" }),"\n")
end

local _set_opfunc = vim.api.nvim_exec2([[
    function s:foo(v)
        let &operatorfunc = a:v
    endfunction
    echo get(function('s:foo'),'name')
]],{ output = true }).output
set_opfunc = vim.fn[_set_opfunc]
M.def_operator = function(name,f)
    vim.keymap.set({"n","v"},name,function()
        set_opfunc(function()
            local start = vim.fn.getpos("'[")
            local finish = vim.fn.getpos("']")
            f(start,finish)
        end)
        return "g@"
    end,{ expr = true })
end

M.def_textobject = function(name,def)
    set("v",name,def)
    set("o",name,"<cmd>normal v" .. name .. "<cr>")
end

-- <c-w>の拡張
set("n","<c-w>T","<cmd>split | buffer term:<cr>") -- 楽にterminal bufferを使う

M.def_operator("gs",function(s,e)
    search(get_region(s,e))
end)

set("n","gss",function()
    search(vim.api.nvim_get_current_line())
end)

-- scrollbind
set("n","<leader>O",function() -- scrOllbind
    vim.o.scrollbind = false
end)
set("n","<leader>o",function()
    vim.o.scrollbind = true
end)


set("n","<leader>i",'pmq`[mz`qx`zP') -- 入れ換える "hoge,fuga" を "fuga,hoge" にするなど
M.def_textobject("if","T/ot/") -- ファイルパスやSKK辞書を編集するため
M.def_textobject("af","T/of/") -- ファイルパスやSKK辞書を編集するため
set('n','<leader>!',function()
    local cmd = vim.fn.getreg(":")
    local bang_cmd = r.gsub("!")("(^\\a+)@<=( |$)@=")(cmd)
    return ":" .. bang_cmd .. "\n" -- 直接コマンドを実行するとエラーメッセージが派手
end,{ expr = true }) -- 前回実行したコマンドを強制実行する
set('t','<esc>','<c-\\><c-n>')
set('t','<c-\\><esc>','<esc>')
set('v','<leader>s','"qy:%s/\\V<c-r>"') set('n','<leader>s',[["qyiw:%s/\V\<<c-r>"\>]]) set('n','<leader>S',[["qyiw:'<,'>s/\V\<<c-r>"\>]]) -- Substitute
set('n','<leader>b',"<cmd>ls<cr>") -- Bufferを一覧で見る
set('n','<leader>B',"<cmd>ls!<cr>") -- すべてのBufferを一覧で見る
set('n','<leader>T',"<cmd>tabs<cr>") -- Tabpageを一覧で見る
set("n","<leader>I","<cmd>Inspect<cr>") -- Inspect
set('n','<c-n>','<cmd>bnext<cr><c-g>') -- Next
set('n','<c-p>','<cmd>bprevious<cr><c-g>') -- Previous
local function update_cmdline(fn) return function()
    vim.fn.setcmdline(fn(vim.fn.getcmdline()))
end end

set('c','<c-u>',update_cmdline(r.remove("[/ ]@<=[^/]*.$"))) -- Up ファイル名補完で親ディレクトリに移動する

-- レジスタを楽に編集 -- https://zenn.dev/ryoppippi/articles/e2ad1047bc950c をもとに作成
set('n','<leader>r',function()
    local reg_name = vim.fn.getcharstr()
    local reg_content = vim.fn.getreg(reg_name)
    vim.ui.input({
        prompt = "let @" .. reg_name .. ": ",
        default = reg_content
    },function(input)
        -- <esc>した時にはレジスターの内容を変更しない
        if input then
            vim.fn.setreg(reg_name,input)
        end
    end)
end,{ desc = "edit register" })
set("n","<leader>r<esc>","") -- vim.opt.showcmd = true においていい感じに表示するため

return M
