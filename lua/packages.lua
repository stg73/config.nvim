local M = {}

local gh = function(x) return "https://github.com/" .. x end

function M.setup()
vim.pack.add({
    -- gh "skanehira/jumpcursor.vim",
    gh "folke/tokyonight.nvim",
    -- gh "rktjmp/hotpot.nvim",
    gh "rbtnn/vim-ambiwidth",
},{ load = true })

require("tokyonight").load({
    terminal_colors = false,
    transparent = true,
    style = "night",
    styles = {
        keywords = { italic = false },
    },
})

nvim_on("CmdlineEnter",vim.api.nvim_create_augroup("lazyload"),function()
    vim.pack.add({
        gh "vim-jp/vimdoc-ja",
        gh "vim-jp/nvimdoc-ja",
        gh "tpope/vim-surround",
    },{ load = true })

    local fp = require("fp")
    fp.items(function(k,v)
        vim.keymap.set("n",k .. "<esc>","")
        vim.keymap.set("n",k,v)
    end) {
        sd = '<Plug>Dsurround',
        ss = '<Plug>Yssurround',
        sS = '<Plug>YSsurround',
        sa = '<Plug>Ysurround',
        sr = '<Plug>Csurround',
        sR = '<Plug>CSurround',
        s = "",
    }
    vim.keymap.set('v','s','<Plug>VSurround')

    vim.schedule(function()
        fp.map(function(lhs)
            vim.keymap.del("n",lhs)
        end) {
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
    end)

    return true
end)
end

return M
