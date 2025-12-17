vim.loader.enable(true) -- よく分からない

-- ローカルのプラグイン読み込み
vim.tbl_map(function(name) vim.opt.runtimepath:append(vim.env.works .. "/" .. name .. ".nvim") end,{
    "modules", "jump_cursor", "syntax"
})

regex = require("regex")
tbl = require("tbl")
str = require("string_utils")
skk = require("skk")
char = require("character_table")

-- 拡張
vim.keymap.get = require("get_keymap").get

vim.g.mapleader = "-"

pkg = require("packages")
require("commands")
require("keymaps")
require("highlights")
require("options")

-- プラグイン
vim.keymap.set({"o","n","v"},"<leader>j",require("select_position").opt().set_cursor)
vim.keymap.set({"o","n","v"},"<leader><leader>",require("select_position").opt({ character = "/s" }).set_cursor)

-- デフォルトプラグインを無効化
tbl.map(function(plugin) vim.g["loaded_" .. plugin] = 1 end)({
    "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers"
})

-- シンタクスハイライト
vim.g.gitcommit_prefix = { "feat", "fix", "change", "docs", "improve", "refactor", "revert", "style", "update", }

-- autocmdを楽に作る
local group = vim.api.nvim_create_augroup('init',{})
local function create_autocmd(event,opts)
    vim.api.nvim_create_autocmd(event,vim.tbl_extend('force',{
        group = group
    },opts))
end

create_autocmd({"bufenter","termopen"},{ -- オプションを強制する
    callback = function()
        vim.opt.number = true
    end
})

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

-- 環境変数

-- 便利なもの
vim.env.i = vim.env.myvimrc -- Init.lua
vim.env.n = regex.gsub"//""\\"(vim.fs.dirname(vim.env.i)) -- Init.lua
vim.env.c = vim.env.xdg_config_home -- Config
vim.env.w = vim.env.works -- Works
vim.env.f = vim.env.forks -- Forks
vim.env.s = vim.env.appdata .. '/CorvusSKK' -- corvusSkk
vim.env.d = vim.env.works .. "/dictionaries.skk" -- skk-Dictionary
vim.env.l = vim.env.works .. "/modules.nvim/lua" -- Lua-modules
vim.env.t = vim.env.home .. "/test" -- Test
vim.env.m = vim.env.home .. "/memos" -- Memos

-- neovimの中で起動した場合はgitのエディタとしてnvrを使う
vim.env.git_editor = 'nvr -cc split -c "set bufhidden=delete" --remote-wait'

vim.api.nvim_create_user_command("S",[[silent SkkAnnotate | SkkSort | write | execute "normal \<c-w>T"]],{bar = true}) -- 注釈を追加 ソート コミット

vim.api.nvim_create_user_command("NuHighlight",function()
    local w0 = vim.fn.line("w0")
    local pos = vim.api.nvim_win_get_cursor(0)

    vim.cmd.terminal("open % | nu-highlight")

    vim.fn.feedkeys(w0 .. "Gzt","n")
    vim.print(pos)
    vim.schedule_wrap(function() vim.api.nvim_win_set_cursor(0,pos) end)
end,{})

-- helpを右側にいい感じに出すため
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

do
    local extui = require("vim._extui")

    vim.o.cmdheight = 0
    extui.enable({
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
            require("vim._extui.shared").cfg.msg.target = "msg" -- 既定では 1 にすると "cmd" になる
        end,
    })
    vim.api.nvim_create_autocmd("RecordingLeave",{
        group = group,
        nested = true, -- extuiにオプションを反映する
        callback = function()
            vim.o.cmdheight = 0
        end,
    })

    -- tOggle
    vim.keymap.set("n","<leader>o",function()
        vim.o.cmdheight = vim.o.cmdheight == 0 and 1 or 0
        require("vim._extui.shared").cfg.msg.target = "msg"
    end)
end
