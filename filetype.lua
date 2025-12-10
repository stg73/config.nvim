vim.filetype.add({
    extension = {
        skk = "skk-specialized",
        bnf = "bnf",
        bak = function(path,bufnr) -- もとのファイル名を推測してファイルタイプを決定する
            return vim.filetype.match({
                filename = require("string_utils").get.original_name_of_backup_file(path),
                buf = bufnr
            })
        end,
    },
    filename = {
        ["skkdict.txt"] = "skk", -- corvusskkの普通の辞書
        ["userdict.txt"] = "skk-users", -- corvusskkのユーザ辞書
    },
    pattern = {
        ["SKK%-JISYO%..+"] = "skk", -- "SKK-JISYO.*"系
        ["tags%-.+"] = "tags", -- "tags-ja"などに対応させる
    }
})

-- 検索コマンドラインウィンドウのファイルタイプを設定する
vim.api.nvim_create_autocmd('CmdWinEnter',{
    group = vim.api.nvim_create_augroup("set-filetype-of-search-window",{}),
    pattern = {"/","?"},
    callback = function()
        vim.bo.filetype = "regex"
    end,
})
