local h = vim.api.nvim_set_hl

h(0,'normalnc',{bg = 'none'})
h(0,'@keyword',{fg = '#9d7cd8'})
h(0,'keyword',{fg = '#ae8de9'})
h(0,'constant',{fg = '#dd8d53'})
h(0,'comment',{fg = '#676f9a'})
h(0,'string',{fg = '#8dbd59'})
h(0,'@punctuation.bracket',{fg = '#cc6666'})

-- neovim側の色
h(0,'Question',{fg = '#5880d5'}) -- できるだけ目立たないように
h(0,'visual',{bg = '#4a5679'})
h(0,'linenr',{fg = '#565f89'})
h(0,'linenc',{link = 'linenr'})
h(0,'statuslinenc',{link = 'linenr'})
h(0,'winseparator',{link = 'linenr'})
h(0,'statusline',{link = 'linenr'})
