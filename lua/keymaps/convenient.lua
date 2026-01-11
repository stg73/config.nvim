local M = {}

local k = vim.keymap.set
local r = require("regex")

function M.setup()
-- <c-w>の拡張
k("n","<c-w>T","<cmd>split | buffer term:<cr>") -- 楽にterminal bufferを使う
k("n","<c-w>N","<cmd>botright split | enew | set bufhidden=delete<cr>")

-- 検索系
local search = function(str)
    return vim.system({"nu","--commands","start 'https://google.com/search?q=" .. str .. "'"})
end

k("v","gs",function()
    local v_range = table.concat(vim.fn.getregion(vim.fn.getpos("."), vim.fn.getpos("v"), { type = vim.fn.mode() }),"")
    search(v_range)
end)

k("n","gs",function()
    search(vim.fn.expand("<cword>"))
end)

k("n","gss",function()
    search(vim.api.nvim_get_current_line())
end)

-- scrollbind をトグル
k("n","<leader>O",function() -- scrOllbind
    vim.o.scrollbind = not vim.o.scrollbind
end)

k("n","<leader>i",'pmq`[mz`qx`zP') -- 入れ換える
k("n","<leader>f","T/vf/") -- ファイルパスやSKK辞書を編集するため
k('n','<leader>!',function()
    local cmd = vim.fn.getreg(":")
    local bang_cmd = r.gsub("!")("(^/a+)@<=( |$)@=")(cmd)
    return ":" .. bang_cmd .. "\n" -- 直接コマンドを実行するとエラーメッセージが派手
end,{ expr = true }) -- 前回実行したコマンドを強制実行する
k('i','<leader>n','<esc>') k('t','<leader>n','<c-\\><c-n>') k('c','<leader>n','<cr>')
k('n','<leader>n','a<cr><esc><c-\\><c-n>') -- 上にだいたい同じ
k('v','<leader>l','"qy:lua <c-r>"<cr>j') k('n','<leader>l','vv<leader>l',{remap = true}) -- Lua バッファの文字列をluaとして実行する
k('v','<leader>s','"qy:%s/\\V<c-r>"') k('n','<leader>s',[["qyiw:%s/\V\<<c-r>"\>]]) k('n','<leader>S',[["qyiw:'<,'>s/\V\<<c-r>"\>]]) -- Substitute
k('n','<leader>b',function() -- "<cmd>ls<cr>" だと上部に空行ができてしまう
    local buf_list = vim.api.nvim_exec2("ls",{ output = true }).output
    vim.api.nvim_echo({{buf_list}},false,{})
end) -- Bufferを一覧で見る
k('n','<leader>B',':ls<cr>:b ') -- Bufferを一覧で見て開く
k('v','<leader>e','"qy<c-w>wpa<cr><c-\\><c-n>G<c-w>p') k('n','<leader>e','vv<leader>e',{remap = true}) -- Execute 次のウィンドウのターミナルで実行する
k('c','<leader>e','<c-f>"qyy<c-w>cpA<cr><c-\\><c-n>G',{silent = true}) -- Execute コマンドラインモードからカレントバッファのterminalでコマンドを実行
k("n","<leader>I","<cmd>Inspect<cr>") -- Inspect
-- cmwin 用マッピング
vim.api.nvim_create_autocmd('cmdwinenter',{
    group = vim.api.nvim_create_augroup("my-cmdwin",{}),
    callback = function()
        k('v','<leader>e','"qy<c-w>cpA<cr><c-\\><c-n>G',{ buffer = true })
        k('i','<leader>r','<esc>ld$o<c-r>"<esc>I',{ buffer = true })
        k("n","<leader>n","<cr>",{ buffer = true })
    end,
})
k('n','<c-n>','<cmd>bnext | execute "normal \\<c-g>"<cr>') -- Next
k('n','<c-p>','<cmd>bprevious | execute "normal \\<c-g>"<cr>') -- Previous
local function set_cmdline(fn) return function()
    vim.fn.feedkeys(vim.keycode("<c-\\>e")) -- 編集モードに入る
    local cmd = vim.fn.getcmdline()
    local expr = "'" .. vim.fn.escape(fn(cmd),"'") .. "'"
    vim.fn.feedkeys(expr .. '\r',"n")
end end

k('c','<c-u>',set_cmdline(r.remove("[// ]@<=[^//]*.$"))) -- Up ファイル名補完で親ディレクトリに移動する

-- レジスタを楽に編集 -- "https://zenn.dev/ryoppippi/articles/e2ad1047bc950c"をもとに作成
k('n','<leader>r',function()
    local reg_name = vim.fn.getcharstr()
    local reg_content = vim.fn.getreg(reg_name)
    vim.ui.input({
        prompt = "let @" .. reg_name .. ": ",
        default = reg_content
    },
    function(input)
        -- <esc>した時にはレジスターの内容を変更しない
        if input then
            vim.fn.setreg(reg_name,input)
        end
    end)
end,{ desc = "edit register" })
k("n","<leader>r<esc>","") -- vim.opt.showcmd = true においていい感じに表示するため
end

return M
