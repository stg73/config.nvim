vim.cmd([[
syntax keyword cssTagName search
syntax keyword cssMediaProp prefers-color-scheme
syn keyword cssTextProp contained text-underline-offset color-scheme scroll-margin-top
]])

local l = require("highlight").link

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
