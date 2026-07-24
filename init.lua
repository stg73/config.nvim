vim.loader.enable()

-- ローカルのプラグインをruntimepathに追加
vim.tbl_map(function(name) vim.opt.runtimepath:append(vim.env.works .. "/" .. name .. ".nvim") end,{
    "modules", "jump_cursor", "syntax", "ghosttext", "socket",
})

regex = require("regex")
fp = require("fp")
str = require("str_util")
skk = require("skk")
char = require("char_map")

-- 拡張
vim.keymap.get = require("get_keymap").get

vim.g.mapleader = "-"
fp.items(function(k,v)
    vim.keymap.set({"n","i","v","c","t","o"},"<leader>" .. k,v)
end) {
    [""] = "",
    ["<leader>"] = "<leader>",
    ["<esc>"] = "",
}

pkg = require("packages").module
fp.map(function(config)
    require(config).setup()
end) {
    "packages",
    "commands",
    "keymaps",
    "highlights",
    "options",
    "ui2",
}
fp.items(vim.fn.setenv)(require("env"))

-- プラグイン
vim.keymap.set({"o","n","v"},"<leader>j",require("select_pos").opt().set_cursor)
vim.keymap.set({"o","n","v"},"<leader><leader>",require("select_pos").opt({ character = "\\s" }).set_cursor)

require("ghosttext").start()
vim.cmd.packadd("nvim.undotree")

-- デフォルトプラグインを無効化
fp.map(function(plugin) vim.g["loaded_" .. plugin] = true end)({
    "netrwPlugin", "gzip", "zipPlugin", "tutor_mode_plugin", "tarPlugin"
})

-- シンタクスハイライト
vim.g.gitcommit_prefix = { "feat", "fix", "docs", "improve", "refactor", "style", "update", "init", }

local group = vim.api.nvim_create_augroup('init',{})

vim.api.nvim_create_autocmd({"bufenter","termopen"},{ -- オプションを強制する
    group = group,
    callback = function()
        vim.opt.number = true
    end
})

-- 起動時にterminalを開く
vim.api.nvim_create_autocmd('vimenter',{
    group = vim.api.nvim_create_augroup("open-terminal-on-vimenter",{}),
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

vim.api.nvim_create_user_command("S",[[SkkAnnotate | SkkSort | write | execute "normal \<c-w>T"]],{bar = true}) -- 注釈を追加 ソート コミットするためterminalを出す

-- helpを右側にいい感じに出す
local set_help_position = function()
    if vim.bo.buftype == "help" then
        vim.cmd("wincmd L | vertical resize 85")
        vim.opt.list = true
    end
end
vim.api.nvim_create_autocmd("BufWinEnter",{
    group = vim.api.nvim_create_augroup("open-help-to-the-right",{}),
    callback = vim.schedule_wrap(set_help_position), -- scheduleを挟まないとbuftypeが判断できない
})

-- treesitter
vim.api.nvim_create_autocmd("filetype",{
    group = vim.api.nvim_create_augroup("treesitter",{}),
    callback = function()
        pcall(vim.treesitter.start) -- ゴリ押し
    end,
})

-- カスタムURLスキーム
local s = require("url_scheme")
s.init()
s.add {
    ht = require("open_webpage").open,
    gh = require("open_github").open,
}

local group = vim.api.nvim_create_augroup("filetype-settings",{})
vim.api.nvim_create_autocmd("FileType",{
    pattern = "help",
    group = group,
    callback = function()
        -- vim.bo.iskeyword = vim.filetype.get_option("lua","iskeyword")
        require"syntax".syntax "error" { match = "%>78v.*." }
    end,
})

-- コマンドラインモードの <c-w> の挙動を統一する
local iskeyword = vim.filetype.get_option("vim","iskeyword")
local original -- 状態を保存する
local group = vim.api.nvim_create_augroup("cmdline-iskeyword",{}),
vim.api.nvim_create_autocmd("CmdLineEnter",{
    group = group,
    callback = function()
        original = vim.bo.iskeyword
        vim.bo.iskeyword = iskeyword
    end,
})
vim.api.nvim_create_autocmd("CmdLineLeave",{
    group = group,
    callback = function()
        vim.bo.iskeyword = original
    end,
})

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

nvim = require("nvim")

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
local group = vim.api.nvim_create_augroup("manage_nvim_serverlist",{})
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

