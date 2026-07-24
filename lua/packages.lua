local M = {}

local P = require("package_manager").dir(vim.env.home .. "/test/package")

local gh = function(x) return "https://github.com/" .. x end
local packages = {
    { repo = gh "skanehira/jumpcursor.vim", desc = "いい感じにカーソルを動かす" },
    { repo = gh "vim-jp/vimdoc-ja", desc = "日本語ヘルプ" },
    { repo = gh "vim-jp/nvimdoc-ja", desc = "日本語ヘルプ" },
    { repo = gh "tpope/vim-surround" },
    { repo = gh "folke/tokyonight.nvim", desc = "カラースキーム" },
    { repo = gh "rktjmp/hotpot.nvim", desc = "Fennel" },
    { repo = gh "rbtnn/vim-ambiwidth" }
}

-- P.install_table(packages)

local load = {
    ["vim-ambiwidth"] = {},
    ["hotpot.nvim"] = {
        lazy = {
            cmd = "Fnl"
        }
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
            fp.items(function(k,v)
                vim.keymap.set("n",k .. "<esc>","")
                vim.keymap.set("n",k,v)
            end){
                sd = '<Plug>Dsurround',
                ss = '<Plug>Yssurround',
                sS = '<Plug>YSsurround',
                sa = '<Plug>Ysurround',
                sr = '<Plug>Csurround',
                sR = '<Plug>CSurround',
                s = "",
            }
            vim.keymap.set('v','s','<Plug>VSurround')

            fp.map(function(lhs)
                vim.keymap.del("n",lhs)
            end){
                'ds',
                'yss',
                'ySs',
                'ySS',
                'yS',
                'ys',
                'cs',
                'cS',
            }
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
