local M = {}

local k = vim.keymap.set

function M.setup()
    k("i","<right>","<c-g>U<right>")
end

return M
