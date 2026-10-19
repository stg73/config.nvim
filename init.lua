vim.loader.enable()

local is_main_computer = vim.fn.has "win32" == 1
local is_using_tiling_window_manager = vim.fn.has "win32" == 0
local use_nvim_as_terminal_multiplexer = not is_using_tiling_window_manager

if is_main_computer then
    -- ローカルのプラグインをruntimepathに追加
    vim.tbl_map(function(name) vim.opt.runtimepath:append("~/works/" .. name .. ".nvim") end,{
        "modules", "jump_cursor", "syntax", "skk", "ghosttext", "socket",
    })
else
    local gh = function(x) return "https://github.com/stg73/" .. x .. ".nvim" end
    vim.pack.add {
        gh "modules",
        gh "jump_cursor",
        gh "syntax",
        gh "skk",
    }
end

regex = require("regex")
fp = require("fp")

fp.items(function(k,v)
    vim.keymap.set({"i","c","t"},"<leader>" .. k,v)
end) {
    [""] = "",
    ["<leader>"] = "<leader>",
    ["<esc>"] = "",
}

if vim.fn.has "nvim-0.13" == 1 then
    nvim_on = require"vim._core.util".nvim_on
else
    function nvim_on(events, group, opts_or_fn, fn)
        vim.validate('opts_or_fn', opts_or_fn, { 'function', 'table' })
        local opts --- @type vim.api.keyset.create_autocmd
        if type(opts_or_fn) == 'function' then
            fn, opts = opts_or_fn, {}
        else
            opts = opts_or_fn
        end
        opts.group = group
        opts.callback = fn
        return vim.api.nvim_create_autocmd(events, opts)
    end
end

local im_off = function()
    if vim.fn.has "win32" == 1 then
        vim.system { "win-im-ctl", "set-mode", "0" }
    end
end
nvim_on("ModeChanged",vim.api.nvim_create_augroup("IM",{}),{ pattern = "*:n*" },im_off)
-- 本来なら ModeChanged で十分だが、稀に ModeChanged が発生しないことがあるのでその対策
nvim_on("CmdLineLeave","IM",im_off)

if use_nvim_as_terminal_multiplexer then
    require "terminal_multiplexer"
end

fp.map(function(config)
    require(config)
end) {
    "packages",
    "keymaps",
    "highlights",
    "options",
    "ui2",
}
fp.items(vim.fn.setenv)(require("env"))

-- プラグイン
vim.keymap.set({"o","n","v"},"<leader>j",require("select_pos").opt().set_cursor)
vim.keymap.set({"o","n","v"},"<leader><leader>",require("select_pos").opt({ character = "\\s" }).set_cursor)

-- デフォルトプラグインを無効化
fp.map(function(plugin) vim.g["loaded_" .. plugin] = true end)({
    "netrwPlugin", "gzip", "zipPlugin", "tutor_mode_plugin", "tarPlugin"
})

-- シンタクスハイライト
vim.g.gitcommit_prefix = { "feat", "fix", "docs", "improve", "refactor", "style", "update", "init", }

if is_main_computer then
    require("ghosttext").start()
end
nvim_on("CmdlineEnter",nil,function()
    require("excmds")
    vim.cmd.packadd("nvim.undotree")

    -- 拡張
    vim.keymap.get = require("get_keymap").get

    -- カスタムURLスキーム
    local s = require("url_scheme")
    s.init()
    s.add {
        ht = require("open_webpage").open,
        gh = require("open_github").open,
    }

    nvim = require("nvim")

    return true
end)

-- helpを右側にいい感じに出す
local set_help_position = function()
    if vim.bo.buftype == "help" then
        vim.cmd("wincmd L | vertical resize 85")
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

-- コマンドラインモードの <c-w> の挙動を統一する
local iskeyword = "@,48-57,_,192-255,#"
local original -- 状態を保存する
local group = vim.api.nvim_create_augroup("cmdline-iskeyword",{})
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
