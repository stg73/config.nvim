local prefixes = "(" .. table.concat(vim.g.gitcommit_prefix,"|") .. ")"
vim.cmd([[
    syntax match prefix_gitcommit '\v^]] .. prefixes .. [[!?(\(.{-1,}\))?:' contained containedin=gitcommitSummary
]])
vim.cmd([[
    syntax match bracket_prefix_gitcommit '\v\(|\)' contained containedin=prefix_gitcommit
    syntax match argument_prefix_gitcommit '\v\(@<=.{-}\)@=' contained containedin=prefix_gitcommit
    syntax match string_gitcommit '\v".{-}"' contained containedin=gitcommitSummary
]])

vim.api.nvim_set_hl(0,'prefix_gitcommit',{link = '@function'})
vim.api.nvim_set_hl(0,'bracket_prefix_gitcommit',{link = '@punctuation.bracket'})
vim.api.nvim_set_hl(0,'argument_prefix_gitcommit',{link = '@variable'})
vim.api.nvim_set_hl(0,'string_gitcommit',{link = '@string'})
