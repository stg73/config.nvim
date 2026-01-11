local M = {}

function M.setup()
vim.env.i = vim.env.myvimrc -- Init.lua
vim.env.n = vim.fs.dirname(vim.env.i) -- Nvim
vim.env.c = vim.env.xdg_config_home -- Config
vim.env.w = vim.env.works -- Works
vim.env.f = vim.env.forks -- Forks
vim.env.s = vim.env.appdata .. '/CorvusSKK' -- corvusSkk
vim.env.d = vim.env.works .. "/dictionaries.skk" -- Dictionaries.skk
vim.env.l = vim.env.works .. "/modules.nvim/lua" -- Lua
vim.env.t = vim.env.home .. "/test" -- Test
vim.env.m = vim.env.home .. "/memos" -- Memos
end

return M
