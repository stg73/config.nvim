local s = require("syntax").syntax
s "nuVarMember" { match = [[(\$\S+\.)@<=\S+]], contained = true, containedin = "nuVar" }
s "nuPipe" { match = "\\|" }
s "nuBracket" { match = "[}{]" }
s "nuProperty" { match = "\\w+:@=" }

local l = require("syntax").link

l "nuVarMember" "@variable.member"
l "nuPipe" "@punctuation.delimiter"
l "nuBracket" "@punctuation.bracket"
l "nuProperty" "@property"

l "nuVar" "@variable"
l "nuString" "@string"
l "nuFlag" "@variable.member"
l "nuCmd" "@function"
l "nuCondi" "@keyword.conditional"
