local M = {}

local k = vim.keymap.set

function M.setup()
    k({'n','i','v','c','o'},'<up>','<c-k>',{remap = true}) -- <c-k>で<up>になるようにしているから
    k({'n','i','v','c','o'},'<down>','<c-e>',{remap = true}) -- 〃
    k({'n','v','o'},'<left>','<c-h>',{remap = true}) -- 〃
    k({'n','v','o'},'<right>','<c-l>',{remap = true}) -- 〃
    k({'i','v','c','o'},'<c-m>','<c-l>') -- l 括弧内入力の後に続けて打つため
    k("i","<right>","<c-g>U<right>")
end

return M
