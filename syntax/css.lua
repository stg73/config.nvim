vim.cmd([[
syntax keyword cssTagName search
syntax keyword cssMediaProp prefers-color-scheme
syn keyword cssTextProp contained text-underline-offset color-scheme scroll-margin-top
]])

local h = require("highlight").set

h "cssBraces" { link = "@punctuation.bracket" }
h "cssTagName" { link = "special" }
h "cssProp" { link = "@property" }
h "cssNoise" { link = "@operator" }
h "cssSelectorOp2" { link = "@operator" }
h "cssSelectorOp" { link = "@punctuation.bracket" }
h "cssUnitDecorators" { link = "@keyword.operator" }
h "cssAttributeSelector" { link = "@property" }
h "cssAttrComma" { link = "@punctuation.delimiter" }
h "cssIdentifier" { link = "keyword" }
