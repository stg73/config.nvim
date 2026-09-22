-- Nvimのアドレスのリストをファイルに保存する
-- nvim --serverlist の代わり
-- これを利用するもの: https://github.com/stg73/config.nu/blob/main/neovim-remote.nu
local function update_addresses(file) return function(add_or_remove)
    local content = vim.fn.readfile(file)
    local new_content = fp.filter(function(server) return server ~= vim.v.servername end)(content)
    if add_or_remove then
        table.insert(new_content,vim.v.servername)
    end
    vim.fn.writefile(new_content,file)
end end

local update = update_addresses(vim.env.XDG_STATE_HOME .. "/nvim_serverlist")
local group = vim.api.nvim_create_augroup("manage_nvim_serverlist")
vim.api.nvim_create_autocmd({"VimEnter","FocusGained"},{
    group = group,
    callback = function()
        update(true)
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre",{
    group = group,
    callback = function()
        update(false)
    end,
})

-- 起動時にterminalを開く
vim.api.nvim_create_autocmd('vimenter',{
    group = vim.api.nvim_create_augroup("open-terminal-on-vimenter"),
    nested = true, -- terminal自動コマンド用
    callback = function()
        local buf_content = table.concat(vim.api.nvim_buf_get_lines(0,0,-1,false),'\n')
        local buf_name = vim.api.nvim_buf_get_name(0)
        if buf_content .. buf_name == "" then
            vim.cmd.terminal()
        end
    end
})

-- neovimの中で起動した場合はgitのエディタとしてnvrを使う
vim.env.git_editor = 'nvr -cc split -c "set bufhidden=delete" --remote-wait'

nvim_on("CmdlineEnter",nil,function()
    -- neovimのコマンドラインをシェルのコマンドラインとして使う
    local escape_tmode = vim.keycode("<c-\\><c-n>")
    function enter_shell_cmdline(opts)
        opts = opts or {}
        opts.timeout = opts.timeout or 160
        opts.filetype = opts.filetype or "nu"

        vim.bo[require("vim._core.ui2").bufs.cmd].syntax = opts.filetype -- 使うシェルのハイライト
        vim.ui.input({
            prompt = ":",
            completion = "shellcmdline",
        },function(input)
            if input then
                vim.fn.feedkeys("a" .. input .. "\r" .. escape_tmode,"n")
                vim.defer_fn(function()
                    enter_shell_cmdline(opts)
                    vim.fn.feedkeys("G","n")
                end,opts.timeout)
            end
        end)
    end

    return true
end)
