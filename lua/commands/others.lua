local M = {}

function M.setup()
vim.api.nvim_create_user_command('Normal','<line1>,<line2>g/^/execute "normal <args>" | nohlsearch',{range = true,bar = true,nargs = 1}) -- normalのラッパー エスケープで制御文字が使える rangeが指定できる パイプが使える
vim.api.nvim_create_user_command('Todo','split ~/memos/todo.txt | set nobuflisted',{bar = true})

return M
