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

vim.api.nvim_set_hl(0,"property_powershell",{link = "@property"})
vim.api.nvim_set_hl(0,"member_powershell",{link = "@variable.member"})
vim.api.nvim_set_hl(0,"bracket_powershell",{link = "@punctuation.bracket"})
vim.api.nvim_set_hl(0,"variableParameter_powershell",{link = "@variable.parameter"})
    vim.api.nvim_set_hl(0,"delimiter_variableParameter_powershell",{link = "@punctuation.delimiter"})

-- 元から存在するハイライトグループ
vim.api.nvim_set_hl(0,"ps1escape",{link = "@string.escape"})
vim.api.nvim_set_hl(0,"ps1Interpolation",{link = "@punctuation.bracket"})
vim.api.nvim_set_hl(0,"ps1Variable",{link = "@variable"})
vim.api.nvim_set_hl(0,"ps1Label",{link = "@property"})
vim.api.nvim_set_hl(0,"ps1cmdlet",{link = "@function.builtin"})
vim.api.nvim_set_hl(0,"ps1function",{link = "function"})
