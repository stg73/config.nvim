local M = {}

local k = vim.keymap.set
local r = require("regex")

function M.setup()
-- <c-w>の拡張
k("n","<c-w>T","<cmd>split | buffer term:<cr>") -- 楽にterminal bufferを使う

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
    k("v",name,def)
    k("o",name,"<cmd>normal v" .. name .. "<cr>")
end

M.def_operator("gs",function(s,e)
    search(get_region(s,e))
end)

k("n","gss",function()
    search(vim.api.nvim_get_current_line())
end)

-- scrollbind
k("n","<leader>O",function() -- scrOllbind
    vim.o.scrollbind = false
end)
k("n","<leader>o",function()
    vim.o.scrollbind = true
end)


k("n","<leader>i",'pmq`[mz`qx`zP') -- 入れ換える "hoge,fuga" を "fuga,hoge" にするなど
M.def_textobject("if","T/ot/") -- ファイルパスやSKK辞書を編集するため
M.def_textobject("af","T/of/") -- ファイルパスやSKK辞書を編集するため
k('n','<leader>!',function()
    local cmd = vim.fn.getreg(":")
    local bang_cmd = r.gsub("!")("(^\\a+)@<=( |$)@=")(cmd)
    return ":" .. bang_cmd .. "\n" -- 直接コマンドを実行するとエラーメッセージが派手
end,{ expr = true }) -- 前回実行したコマンドを強制実行する
k('i','<leader>n','<esc>') k('t','<leader>n','<c-\\><c-n>') k('c','<leader>n','<cr>')
k('n','<leader>n','a<cr><esc><c-\\><c-n>') -- 上にだいたい同じ
k('v','<leader>s','"qy:%s/\\V<c-r>"') k('n','<leader>s',[["qyiw:%s/\V\<<c-r>"\>]]) k('n','<leader>S',[["qyiw:'<,'>s/\V\<<c-r>"\>]]) -- Substitute
k('n','<leader>b',"<cmd>ls<cr>") -- Bufferを一覧で見る
k('n','<leader>B',"<cmd>ls!<cr>") -- すべてのBufferを一覧で見る
k('n','<leader>T',"<cmd>tabs<cr>") -- Tabpageを一覧で見る
k("n","<leader>I","<cmd>Inspect<cr>") -- Inspect
-- cmwin 用マッピング
vim.api.nvim_create_autocmd('cmdwinenter',{
    group = vim.api.nvim_create_augroup("my-cmdwin"),
    callback = function()
        k('i','<leader>r','<esc>ld$o<c-r>"<esc>I',{ buf = 0 })
        k("n","<leader>n","<cr>",{ buf = 0 })
    end,
})
k('n','<c-n>','<cmd>bnext<cr><c-g>') -- Next
k('n','<c-p>','<cmd>bprevious<cr><c-g>') -- Previous
local function update_cmdline(fn) return function()
    vim.fn.setcmdline(fn(vim.fn.getcmdline()))
end end

k('c','<c-u>',update_cmdline(r.remove("[/ ]@<=[^/]*.$"))) -- Up ファイル名補完で親ディレクトリに移動する

-- レジスタを楽に編集 -- https://zenn.dev/ryoppippi/articles/e2ad1047bc950c をもとに作成
k('n','<leader>r',function()
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
k("n","<leader>r<esc>","") -- vim.opt.showcmd = true においていい感じに表示するため
end

return M
