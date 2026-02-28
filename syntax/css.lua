local s = require("syntax").syntax
s "cssTagName" { keyword = "search"}
s "cssMediaProp" { keyword = "prefers-color-scheme" }
s "cssTextProp" { keyword = { "text-underline-offset", "color-scheme", "scroll-margin-top" }, contained = true }

local l = require("syntax").link

l "cssBraces" "@punctuation.bracket"
l "cssTagName" "special"
l "cssProp" "@property"
l "cssNoise" "@operator"
l "cssSelectorOp2" "@operator"
l "cssSelectorOp" "@punctuation.bracket"
l "cssUnitDecorators" "@keyword.operator"
l "cssAttributeSelector" "@property"
l "cssAttrComma" "@punctuation.delimiter"
l "cssIdentifier" "keyword"
