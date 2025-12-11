vim.cmd([[
    syntax match nuVarMember '\v(\$\S+\.)@<=\S+' contained containedin=nuVar
]])

local l = require("highlights").link

l "nuVarMember" "@variable.member"

l "nuVar" "@variable"
l "nuString" "@string"
l "nuFlag" "@variable.member"
l "nuCmd" "@function"
