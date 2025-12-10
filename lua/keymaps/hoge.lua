local k = vim.keymap.set

-- vimの他のkeybindと機能を揃える
k('i','<cr>','<esc>') -- <cr>で操作を完了・実行する
k('i','<c-c>','<esc>u') -- <c-c>で中断する
k('n','U','<c-r>') -- 大文字にすると逆になる
k('v','v','V') -- 2回押下で行を対象とする
k({'n','v'},'V','<c-v>') -- 非印字文字を使いたくない
k('t','<c-n>','<down>') k('t','<c-p>','<up>') -- commandline modeでの補完と同じにする
k('v','*',[["qy/\V<c-r>=substitute(escape(@q,'\/'),"\n",'\\n','g')<CR><CR>]],{silent = true}) -- ビジュアルモードでも*を使えるように
