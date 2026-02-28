local s = require("syntax").syntax
s "string_text" { match = '".{-}"' }

local l = require("syntax").link

l 'string_text' 'string'
