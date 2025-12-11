local prefixes = "(" .. table.concat(vim.g.gitcommit_prefix,"|") .. ")"
vim.cmd([[
    syntax match prefix_gitcommit '\v^]] .. prefixes .. [[(\(.{-1,}\))?!?:' contained containedin=gitcommitSummary
]])
vim.cmd([[
    syntax match bracket_prefix_gitcommit '\v\(|\)' contained containedin=prefix_gitcommit
    syntax match argument_prefix_gitcommit '\v\(@<=.{-}\)@=' contained containedin=prefix_gitcommit
    syntax match string_gitcommit '\v".{-}"' contained containedin=gitcommitSummary
]])

local l = require("highlights").link

l 'prefix_gitcommit' '@function'
l 'bracket_prefix_gitcommit' '@punctuation.bracket'
l 'argument_prefix_gitcommit' '@variable'
l 'string_gitcommit' '@string'
