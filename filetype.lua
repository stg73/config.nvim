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

-- 検索でシンタクスハイライトが使えるように
local group = vim.api.nvim_create_augroup("highlight-search",{})

-- コマンドラインウィンドウ
vim.api.nvim_create_autocmd('CmdWinEnter',{
    group = group,
    pattern = {"/","?"},
    callback = function()
        if regex.is("[//?]")(vim.fn.getcmdwintype()) then -- "-" や "@" のタイプを避ける
            vim.bo.filetype = "regex"
        end
    end,
})

-- コマンドライン  extui用
vim.api.nvim_create_autocmd("CmdLineEnter",{
    group = group,
    pattern = {"/","?"},
    callback = function()
        local cmdline = require("vim._extui.shared").bufs.cmd
        if regex.is("[//?]")(vim.fn.getcmdtype()) then
            vim.bo[cmdline].syntax = "regex"
        end
    end,
})

vim.api.nvim_create_autocmd("CmdLineLeave",{
    group = group,
    pattern = {"/","?"},
    callback = function()
        local cmdline = require("vim._extui.shared").bufs.cmd
        vim.bo[cmdline].syntax = ""
    end,
})
