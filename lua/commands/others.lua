local M = {}

function M.setup()
vim.api.nvim_create_user_command('Normal','<line1>,<line2>g/^/execute "normal <args>" | nohlsearch',{range = true,bar = true,nargs = 1}) -- normalの上位互換 エスケープで制御文字が使える rangeが指定できる パイプが使える
vim.api.nvim_create_user_command('Todo','split ~/memos/todo.txt | set nobuflisted',{bar = true})

local function g()
    return vim.o.gdefault and "" or "g"
end

-- ANSI color escape codeを除去する
vim.api.nvim_create_user_command("RemoveColor",function(opts)
    local x = vim.fn.getreg("/")
    vim.cmd("silent " .. opts.line1 .. "," .. opts.line2 .. [[substitute/\v\e\[[0-9;]*m//e]] .. g())
    vim.fn.setreg("/",x)
    vim.cmd.nohlsearch()
end,{range = "%",bar = true})

vim.api.nvim_create_user_command("RemoveTrailing",function(opts)
    local x = vim.fn.getreg("/")
    vim.cmd("silent " .. opts.line1 .. "," .. opts.line2 .. [[substitute/\v[\n ]+$//e]] .. g())
    vim.fn.setreg("/",x)
    vim.cmd.nohlsearch()
end,{range = "%",bar = true})

local escape_tmode = vim.keycode("<c-\\><c-n>")

-- neovimのコマンドラインをシェルのコマンドラインのように使う
-- シェルを動かしているターミナルバッファで ":T ls" のように使う
vim.api.nvim_create_user_command("T",
function(opts)
    vim.fn.feedkeys("a" .. opts.args .. "\r" .. escape_tmode,"n") -- terminalでコマンド実行
    vim.fn.timer_start(70,function()
        vim.fn.feedkeys("G:T ","n")
    end) -- 実行を待つ
end,
{nargs = '?'})
end

return M
