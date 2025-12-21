vim.cmd([[
    syntax match nuVarMember '\v(\$\S+\.)@<=\S+' contained containedin=nuVar
    syntax match nuPipe '\v\|'
    syntax match nuBracket '\v[}{]'
    syntax match nuProperty '\v\w+:@='
]])

local l = require("highlights").link

l "nuVarMember" "@variable.member"
l "nuPipe" "@punctuation.delimiter"
l "nuBracket" "@punctuation.bracket"
l "nuProperty" "@property"

l "nuVar" "@variable"
l "nuString" "@string"
l "nuFlag" "@variable.member"
l "nuCmd" "@function"
l "nuCondi" "@keyword.conditional"
