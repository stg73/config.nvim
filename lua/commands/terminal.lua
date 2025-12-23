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
