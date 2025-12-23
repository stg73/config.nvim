local k = vim.keymap.set

-- 文字を楽に入力 キーボードでやるべきことなので 40%キーボードにしたらなくすかもしれない
k({"n","i","v","c","t","o"},"<leader>",'') -- 以下を不自由なく使うために必要
k({"n","i","v","c","t","o"},"<leader><esc>",'') -- 以下を不自由なく使うために必要
k({"n","i","v","c","t","o"},"<leader>i","#") -- Igeta 井桁
k({"n","i","v","c","t","o"},"<leader>p","%") -- Percent sign
k({"n","i","v","c","t","o"},"<leader>k","*",{remap = true}) -- asterisK
k({"n","i","v","c","t","o"},"<leader>c","^") -- Circumflex
k({"n","i","v","c","t","o"},"<leader>t","~") -- Tilde
k({"n","i","v","c","t","o"},"<leader>a","&") -- Ampersand
k({"n","i","v","c","t","o"},"<leader>d","$") -- Dollar mark
k({"n","i","v","c","t","o"},"<leader>v","|") -- Vertical bar
k({"n","i","v","c","t","o"},"<leader>x","!") -- EXclamation mark
k({"n","i","v","c","t","o"},"<leader>q","?") -- Question mark
k({"n","i","v","c","t","o"},"<leader>-","-") -- -
k({"n","i","v","c","t","o"},"<leader>h","/") -- slasH
k({"n","i","v","c","t","o"},"<leader>b","\\") -- Back slash
k({"n","i","v","c","t","o"},"<leader>u","_") -- Under bar
k({"n","i","v","c","t","o"},"<leader>;",":") -- 形が:に似ている
k({"i","v","t","o"},"\t","<cmd>set noexpandtab<cr><cmd>set shiftwidth=8<cr>\t<cmd>set expandtab<cr><cmd>set shiftwidth=4<cr>")
k("i","<leader>r","<cr>") -- Return
k({"i","t","c"},"<c-q>","'") -- Quote scheme用

-- nuMber 大西配列のホーム行の順番
k({"n","i","v","c","t","o"},"<leader>me","0")
k({"n","i","v","c","t","o"},"<leader>mi","1")
k({"n","i","v","c","t","o"},"<leader>ma","2")
k({"n","i","v","c","t","o"},"<leader>mo","3")
k({"n","i","v","c","t","o"},"<leader>m-","4")
k({"n","i","v","c","t","o"},"<leader>mk","5")
k({"n","i","v","c","t","o"},"<leader>mt","6")
k({"n","i","v","c","t","o"},"<leader>mn","7")
k({"n","i","v","c","t","o"},"<leader>ms","8")
k({"n","i","v","c","t","o"},"<leader>mh","9")
