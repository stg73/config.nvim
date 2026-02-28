local prefixes = "(" .. table.concat(vim.g.gitcommit_prefix,"|") .. ")"
local s = require"syntax".syntax
s "prefix_gitcommit" { match = "^" .. prefixes .. [[(\(.{-1,}\))?!?:]], contained = true, containedin = "gitcommitSummary"}
s "bracket_prefix_gitcommit" { match = [[\(|\)]], contained = true, containedin = "prefix_gitcommit"}
s "arguent_prefix_gitcommit" { match = [[\(@<=.{-}\)@=]], contained = true, containedin = "prefix_gitcommit"}
s "string_gitcommit" { match = '".{-}"', contained = true, containedin = "gitcommitSummary"}

local l = require("syntax").link

l 'prefix_gitcommit' '@function'
l 'bracket_prefix_gitcommit' '@punctuation.bracket'
l 'argument_prefix_gitcommit' '@variable'
l 'string_gitcommit' '@string'
