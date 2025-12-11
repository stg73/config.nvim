vim.cmd([[
syntax match hoge '\v.(\..{-1,}>)+' contained containedin=ps1Variable " 下のmemberのハイライトをするために"ps1Variable"を延長
syntax match member_powershell '\v\.@<=<.{-1,}>' contained containedin=hoge
syntax match bracket_powershell '\v[][(){}]' contained containedin=ps1Block
syntax match variableParameters_powershell '\v(^ *function +[^()]+\()@<=[^()]+\)@=' contained containedin=ps1Variable contains=ps1Block
    syntax match variableParameter_powershell '\v\$[^,() ]+' contained containedin=variableParameters_powershell
    syntax match delimiter_variableParameters_powershell ',' contained containedin=variableParameter_powershell

syntax match ps1function '\v(^ *|\()@<=[^ (){}$]+' contained containedin=ps1Block
syntax match property_powershell '\v\l+( +\=)@=' contained containedin=ps1Block

syntax match ps1label '\v @<=--?(\a|-)+' contained containedin=ps1Block
syntax match ps1ScopeModifier '\v\l+:'
syntax match ps1function '\v[^ ().]+(\(.*\))@='
syntax match ps1function '\v(^ *function +)@<=[^ (){}]+'
]])

local l = require("highlights").link

l "property_powershell" "@property"
l "member_powershell" "@variable.member"
l "bracket_powershell" "@punctuation.bracket"
l "variableParameter_powershell" "@variable.parameter"
l "delimiter_variableParameter_powershell" "@punctuation.delimiter"

-- 元から存在するハイライトグループ
l "ps1escape" "@string.escape"
l "ps1Interpolation" "@punctuation.bracket"
l "ps1Variable" "@variable"
l "ps1Label" "@property"
l "ps1cmdlet" "@function.builtin"
l "ps1function" "function"
