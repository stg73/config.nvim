vim.cmd([[
syntax match string_text '\v".{-}"'
]])

local h = require("highlights").set

h 'string_text' { link = 'string' }
