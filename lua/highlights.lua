local M = {}
M.set = require("tbl").curry3(vim.api.nvim_set_hl)(0)
M.link = function(hl) return function(link)
    M.set(hl)({ link = link })
end end

local h = M.set
local l = M.link

h 'normalnc' { bg = 'none' }
h '@keyword' { fg = '#9d7cd8' }
h 'keyword' { fg = '#ae8de9' }
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

return M
