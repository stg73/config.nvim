local env = {
    i = vim.env.MYVIMRC, -- Init.lua
    n = vim.fs.dirname(vim.env.MYVIMRC), -- Nvim
    c = vim.env.XDG_CONFIG_HOME, -- Config
    w = vim.env.HOME .. "/works", -- Works
    f = vim.env.HOME .. "/forks", -- Forks
    d = vim.env.HOME .. "/works/dictionaries.skk", -- Dictionaries.skk
    l = vim.env.HOME .. "/works/modules.nvim/lua", -- Lua
    t = vim.env.HOME .. "/test", -- Test
    m = vim.env.HOME .. "/memos", -- Memos
}
if vim.fn.has "win32" == 1 then
    env.s = vim.env.appdata .. '/CorvusSKK' -- corvusSkk
end

return env
