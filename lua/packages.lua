local P = require("package_manager").directory(vim.env.home .. "/test/package")

-- P.install_table({
--     { repo = "skanehira/jumpcursor.vim", desc = "いい感じにカーソルを動かす" },
--     { repo = "vim-jp/vimdoc-ja", desc = "日本語ヘルプ" },
--     { repo = "vim-jp/nvimdoc-ja", desc = "日本語ヘルプ" },
--     { repo = "subnut/nvim-ghost.nvim", desc = "neovimをブラウザでの入力に使う" },
--     { repo = "tpope/vim-surround" },
--     { repo = "folke/tokyonight.nvim", desc = "カラースキーム" },
-- })

P.load_table({
    ["nvim-ghost.nvim"] = {
        now = true,
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
        event = "CmdLineEnter",
        config = function()
            P.load("vimdoc-ja")
        end
    },
    ["jumpcursor.vim"] = {
        nmap = "<Plug>(jumpcursor-jump)",
        setup = function()
            vim.keymap.set('n','<leader>J','<Plug>(jumpcursor-jump)')
        end,
    },
    ["vim-surround"] = {
        event = "CmdLineEnter",
        config = function()
            local s = require("tbl").curry3(vim.keymap.set)("n")
            s 'sd' '<Plug>Dsurround'   s 'sd<esc>' ''
            s 'ss' '<Plug>Yssurround'  s 'ss<esc>' ''
            s 'sS' '<Plug>YSsurround'  s 'sS<esc>' ''
            s 'sa' '<Plug>Ysurround'   s 'sa<esc>' ''
            s 'sr' '<Plug>Csurround'   s 'sr<esc>' ''
            s 'sR' '<Plug>CSurround'   s 'sR<esc>' ''
            vim.keymap.set('v','s','<Plug>VSurround')

            s "s" ""
            s "s<esc>" ""

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
        now = true,
        config = function()
            require("tokyonight").load({
                terminal_colors = false,
                transparent = true,
                style = "night"
            })
        end,
    },
})

return P
