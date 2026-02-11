vim.loader.enable(true) -- よく分からない

-- ローカルのプラグイン読み込み
vim.tbl_map(function(name) vim.opt.runtimepath:append(vim.env.works .. "/" .. name .. ".nvim") end,{
    "modules", "jump_cursor", "syntax", "ghosttext", "socket",
})

regex = require("regex")
tbl = require("tbl")
str = require("string_utils")
skk = require("skk")
char = require("character_table")

-- 拡張
vim.keymap.get = require("get_keymap").get

vim.g.mapleader = "-"
vim.keymap.set({"n","i","v","c","t","o"},"<leader><leader>","<leader>")
vim.keymap.set({"n","i","v","c","t","o"},"<leader><esc>","")

pkg = require("packages").module
require("packages").setup()
require("commands").setup()
require("keymaps").setup()
require("highlights").setup()
require("options").setup()
require("env").setup()

require("ghosttext").start()

-- プラグイン
vim.keymap.set({"o","n","v"},"<leader>j",require("select_position").opt().set_cursor)
vim.keymap.set({"o","n","v"},"<leader><leader>",require("select_position").opt({ character = "/s" }).set_cursor)

-- デフォルトプラグインを無効化
tbl.map(function(plugin) vim.g["loaded_" .. plugin] = true end)({
    "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers", "gzip", "zipPlugin", "tutor_mode_plugin", "tarPlugin"
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
    group = vim.api.nvim_create_augroup("open-terminal-when-vimenter",{}),
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

vim.api.nvim_create_user_command("S",[[silent SkkAnnotate | SkkSort | write | execute "normal \<c-w>T"]],{bar = true}) -- 注釈を追加 ソート コミット

-- helpを右側にいい感じに出す
vim.api.nvim_create_autocmd("BufWinEnter",{
    group = vim.api.nvim_create_augroup("open-help-to-the-right",{}),
    callback = vim.schedule_wrap(function() -- これを挟まないとbuftypeが判断できない
            if vim.bo.buftype == "help" then
                vim.cmd("wincmd L | vertical resize 85")
                vim.opt.list = true
            end
        end)
})

-- treesitter
local treesitter = vim.api.nvim_create_augroup("treesitter",{})

vim.api.nvim_create_autocmd("filetype",{
    group = treesitter,
    pattern = "markdown",
    callback = function(x)
        vim.treesitter.start(x.buf,"markdown")
    end,
})

vim.api.nvim_create_autocmd("filetype",{
    group = treesitter,
    pattern = "vim",
    callback = function(x)
        vim.treesitter.start(x.buf,"vim")
    end,
})

-- カスタムURLスキーム
local s = require("custom_url_scheme")
s.init()
s.add({
    github = require("open_github").open,
    ht = require("open_webpage").open,
    gh = require("open_github").open,
})

local group = vim.api.nvim_create_augroup("filetype-settings",{})
vim.api.nvim_create_autocmd("FileType",{
    pattern = "help",
    group = group,
    callback = function()
        -- vim.bo.iskeyword = vim.filetype.get_option("lua","iskeyword")
        require"syntax".syntax "error" { match = "%>78v.*." }
    end,
})

do
    local ui2 = require("vim._core.ui2")

    vim.o.cmdheight = 0
    ui2.enable({
        enable = true,
        msg = {
            target = "msg",
            timeout = 2000
        }
    })

    local group = vim.api.nvim_create_augroup("show-recording-message",{})
    vim.api.nvim_create_autocmd("RecordingEnter",{
        group = group,
        nested = true, -- [[\vrecording \@.]] の表示を出す
        callback = function()
            vim.o.cmdheight = 1
            require("vim._core.ui2").cfg.msg.target = "msg" -- 既定では 1 にすると "cmd" になる
        end,
    })
    vim.api.nvim_create_autocmd("RecordingLeave",{
        group = group,
        nested = true, -- ui2にオプションを反映する
        callback = function()
            vim.o.cmdheight = 0
        end,
    })

    -- tOggle
    vim.keymap.set("n","<leader>o",function()
        vim.o.cmdheight = vim.o.cmdheight == 0 and 1 or 0
        require("vim._core.ui2").cfg.msg.target = "msg"
    end)

    -- ui2のblendをset_hlできるようにする
    vim.api.nvim_create_autocmd("FileType",{
        group = vim.api.nvim_create_augroup("winblend",{}),
        pattern = {"msg","pager"},
        callback = function()
            vim.wo.winblend = 1
        end,
    })
end

-- コマンドラインモードの <c-w> の挙動を統一する
vim.api.nvim_create_autocmd("CmdLineEnter",{
    group = vim.api.nvim_create_augroup("cmdline-iskeyword",{}),
    callback = function()
        local iskeyword = vim.bo.iskeyword

        vim.bo.iskeyword = vim.filetype.get_option("vim","iskeyword")

        -- コマンドラインを出たらオプションを復元する
        vim.api.nvim_create_autocmd("CmdLineLeave",{
            once = true,
            callback = function()
                vim.bo.iskeyword = iskeyword
            end
        })
    end
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

local api_words = {
    "win",
    "buf",
    "tabpage",
    "current",
    "create",
    "del",
    "get",
    "set",
    "list",
    "call",
    "parse",
    "open",
    "is",
}

local function parse_name(pattern) return function(name)
    local t = {}
    local function loop(str)
        local s,e = regex.find("^" .. pattern .. "_")(str)
        if s then
            local x,y = string.sub(str,s,e - 1),string.sub(str,e + 1)
            table.insert(t,x)
            if y ~= "" then
                loop(y)
            end
        else
            table.insert(t,str)
        end
    end
    loop(name)
    return t
end end
local parse_api_name = parse_name("(" .. table.concat(api_words,"|") .. ")")

local function set_table(tbl,list)
    local function loop(i,t)
        local is_key = list[i + 1] ~= nil
        if is_key then
            local is_table = list[i + 2] ~= nil
            if is_table then
                if not t[list[i]] then
                    t[list[i]] = {}
                end
                loop(i + 1,t[list[i]])
            else
                loop(i + 1,t)
            end
        else
            t[list[i - 1]] = list[i]
        end
    end

    loop(1,tbl)
end

nvim = {}

for name,fn in pairs(vim.api) do
    local parsed = parse_api_name(regex.remove("nvim_")(name))
    table.insert(parsed,fn)
    set_table(nvim,parsed)
end

-- Nvimのアドレスのリストをファイルに保存する
-- nvim --serverlist の代わり
-- これを利用するもの: https://github.com/stg73/config.nu/blob/main/neovim-remote.nu
local function update_addresses(file) return function(add_or_remove)
    local f = io.open(file,"r")
    local content = vim.split(f:read("a") or "","\n",{ trimempty = true })
    f:close()
    local new_content = tbl.filter(function(server) return server ~= vim.v.servername end)(content)
    if add_or_remove then
        table.insert(new_content,vim.v.servername)
    end
    local f = io.open(file,"w")
    f:write(table.concat(new_content,"\n"))
    f:close()
end end

local update = update_addresses(vim.env.HOME .. "/nvim_addresses")
local group = vim.api.nvim_create_augroup("manage_nvim_addresses",{})
vim.api.nvim_create_autocmd({"VimEnter","FocusGained"},{
    group = group,
    callback = function()
        update(true)
    end,
})

vim.api.nvim_create_autocmd("VimLeave",{
    group = group,
    callback = function()
        update(false)
    end,
})
