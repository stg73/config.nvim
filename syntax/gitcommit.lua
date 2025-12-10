local prefixes = "(" .. table.concat(vim.g.gitcommit_prefix,"|") .. ")"
vim.cmd([[
    syntax match prefix_gitcommit '\v^]] .. prefixes .. [[(\(.{-1,}\))?!?:' contained containedin=gitcommitSummary
]])
vim.cmd([[
    syntax match bracket_prefix_gitcommit '\v\(|\)' contained containedin=prefix_gitcommit
    syntax match argument_prefix_gitcommit '\v\(@<=.{-}\)@=' contained containedin=prefix_gitcommit
    syntax match string_gitcommit '\v".{-}"' contained containedin=gitcommitSummary
]])

local h = require("highlights").set

h 'prefix_gitcommit' { link = '@function' }
h 'bracket_prefix_gitcommit' { link = '@punctuation.bracket' }
h 'argument_prefix_gitcommit' { link = '@variable' }
h 'string_gitcommit' { link = '@string' }
