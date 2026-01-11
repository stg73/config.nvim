local M = {}

M.set = require("tbl").curry3(vim.api.nvim_set_hl)(0)
M.link = function(hl) return function(link)
    M.set(hl)({ link = link })
end end

local h = M.set
local l = M.link

function M.setup()
l "keyword" "@keyword"
h 'constant' { fg = '#dd8d53' }
h 'comment' { fg = '#676f9a' }
h 'string' { fg = '#8dbd59' }
h '@punctuation.bracket' { fg = '#cc6666' }

-- neovim側の色
h 'Question' { fg = '#5880d5' } -- できるだけ目立たないように
h 'visual' { bg = '#4a5679' }
h 'linenr' { fg = '#565f89' }
h 'linenc' { link = 'linenr' }
l 'statuslinenc' 'linenr'
l 'winseparator' 'linenr'
l 'statusline' 'linenr'
h "Pmenu" { bg = "#333344", blend = 20 }
h "PmenuSel" { bg = "#555566", blend = 20 }
h "PmenuMatchSel" { bg = vim.api.nvim_get_hl(0,{name="PmenuSel"}).bg, fg = vim.api.nvim_get_hl(0,{name="special"}).fg }
h "PmenuMatch" { fg = vim.api.nvim_get_hl(0,{name="PmenuMatchSel"}).fg }
h "NormalFloat" { bg = "#333344", blend = 20 }
l "MsgArea" "NormalFloat"
end

return M
