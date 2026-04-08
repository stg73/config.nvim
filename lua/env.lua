return {
    i = vim.env.myvimrc, -- Init.lua
    n = vim.fs.dirname(vim.env.myvimrc), -- Nvim
    c = vim.env.xdg_config_home, -- Config
    w = vim.env.works, -- Works
    f = vim.env.forks, -- Forks
    s = vim.env.appdata .. '/CorvusSKK', -- corvusSkk
    d = vim.env.works .. "/dictionaries.skk", -- Dictionaries.skk
    l = vim.env.works .. "/modules.nvim/lua", -- Lua
    t = vim.env.home .. "/test", -- Test
    m = vim.env.home .. "/memos", -- Memos
}
