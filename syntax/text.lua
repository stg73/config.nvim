vim.cmd([[
syntax match string_text '\v".{-}"'
]])

vim.api.nvim_set_hl(0,'string_text',{link = 'string'})
