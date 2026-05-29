local M = {}

M.default = {
    shellxquote = "",
    shellcmdflag = "-c",
}

M.shells = {
    nu = {
        -- 設定を読み込む 余計な行を表示しない ":%!ls" などが使えるように
        shellcmdflag = "--login --no-newline --stdin --commands",
    },
    pwsh = {
        shellcmdflag = "-Command $PSStyle.OutputRendering = 'PlainText';",
    },
    cmd = {
        shellcmdflag = "/s /c",
        shellxquote = '"',
    },
}

M.options = function(shell)
    return vim.tbl_extend("force",M.default,M.shells[shell] or {})
end

return M
