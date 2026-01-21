local M = {}

local P = require("package_manager").directory(vim.env.home .. "/test/package")

local packages = {
    { repo = "skanehira/jumpcursor.vim", desc = "いい感じにカーソルを動かす" },
    { repo = "vim-jp/vimdoc-ja", desc = "日本語ヘルプ" },
    { repo = "vim-jp/nvimdoc-ja", desc = "日本語ヘルプ" },
    { repo = "subnut/nvim-ghost.nvim", desc = "neovimをブラウザでの入力に使う" },
    { repo = "tpope/vim-surround" },
    { repo = "folke/tokyonight.nvim", desc = "カラースキーム" },
    { repo = "rktjmp/hotpot.nvim", desc = "Fennel" },
}

-- P.install_table(packages)

local load = {
    ["hotpot.nvim"] = {
        lazy = {
            command = "Fnl"
        }
    },
    ["nvim-ghost.nvim"] = {
        config = function()
            -- jugem.jpのリッチテキストエディタの場合に上手くいかない
            vim.api.nvim_create_autocmd('user',{
                group = vim.api.nvim_create_augroup('nvim_ghost_user_autocommands',{}),
                callback = function(x)
                    local nazo_baffa = x.buf + 1 -- 謎に作られるバッファ
                    if vim.api.nvim_buf_is_valid(nazo_baffa) then -- 起動時にもトリガーされるのでその場合は実行しないように
                        vim.cmd.bwipeout(nazo_baffa) -- 邪魔なので削除
                        vim.cmd.tabonly() -- tabpageは好みじゃないので削除
                    end
                end,
            })
        end,
    },
    ["nvimdoc-ja"] = {
        lazy = { event = "CmdLineEnter" },
        -- nvimdoc-ja は翻訳が足りていないので、vim版も使う。
        -- neovim版が見つからない時にvim版を使うように、runtimepath の順を [nvimdoc-ja,vimdoc-ja] にする。
        hook_post = function()
            P.load("vimdoc-ja")
        end
    },
    ["jumpcursor.vim"] = { -- 今は jump_cursor.nvim を使っている
        lazy = {
            keys = {
                { "n", "<Plug>(jumpcursor-jump)" }
            }
        },
        setup = function()
            vim.keymap.set('n','<leader>J','<Plug>(jumpcursor-jump)')
        end,
    },
    ["vim-surround"] = {
        lazy = { event = "CmdLineEnter" },
        hook_post = function()
            local s = require("tbl").curry3(vim.keymap.set)("n")
            local nop = require("tbl").flip(s)("")
            s 'sd' '<Plug>Dsurround'   nop 'sd<esc>'
            s 'ss' '<Plug>Yssurround'  nop 'ss<esc>'
            s 'sS' '<Plug>YSsurround'  nop 'sS<esc>'
            s 'sa' '<Plug>Ysurround'   nop 'sa<esc>'
            s 'sr' '<Plug>Csurround'   nop 'sr<esc>'
            s 'sR' '<Plug>CSurround'   nop 'sR<esc>'
            vim.keymap.set('v','s','<Plug>VSurround')

            nop "s"
            nop "s<esc>"

            local d = require("tbl").curry2(vim.keymap.del)("n")
            d 'ds'
            d 'yss'
            d 'ySs'
            d 'ySS'
            d 'yS'
            d 'ys'
            d 'cs'
            d 'cS'
            vim.keymap.del("v",'S')
        end,
    },
    ["tokyonight.nvim"] = {
        hook_post = function()
            require("tokyonight").load({
                terminal_colors = false,
                transparent = true,
                style = "night",
                styles = {
                    keywords = { italic = false },
                },
            })
        end,
    }
}

function M.setup()
    P.load_table(load)
end

M.module = P

return M
