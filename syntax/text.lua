vim.cmd([[
syntax match string_text '\v".{-}"'
]])

local l = require("highlights").link

l 'string_text' 'string'
