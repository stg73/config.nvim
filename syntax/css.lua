vim.cmd([[
syntax keyword cssTagName search
syntax keyword cssMediaProp prefers-color-scheme
syn keyword cssTextProp contained text-underline-offset color-scheme scroll-margin-top
]])

vim.api.nvim_set_hl(0,"cssBraces",{link = "@punctuation.bracket"})
vim.api.nvim_set_hl(0,"cssTagName",{link = "special"})
vim.api.nvim_set_hl(0,"cssProp",{link = "@property"})
vim.api.nvim_set_hl(0,"cssNoise",{link = "@operator"})
vim.api.nvim_set_hl(0,"cssSelectorOp2",{link = "@operator"})
vim.api.nvim_set_hl(0,"cssSelectorOp",{link = "@punctuation.bracket"})
vim.api.nvim_set_hl(0,"cssUnitDecorators",{link = "@keyword.operator"})
vim.api.nvim_set_hl(0,"cssAttributeSelector",{link = "@property"})
vim.api.nvim_set_hl(0,"cssAttrComma",{link = "@punctuation.delimiter"})
vim.api.nvim_set_hl(0,"cssIdentifier",{link = "keyword"})
