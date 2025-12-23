-- 開括弧を入力すると閉括弧も入力されるように
local k = vim.keymap.set

-- 閉括弧の自動入力
k('i','[','[]<c-G>U<left>')    k({'c','t'},'[','[]<left>')    k({'i','c','t'},'<leader>[','[')
k('i','{','{}<c-G>U<left>')    k({'c','t'},'{','{}<left>')    k({'i','c','t'},'<leader>{','{')
k('i','<','<><c-G>U<left>')    k({'c','t'},'<','<><left>')    k({'i','c','t'},'<leader><','<')

-- 日本語
k('i','「','「」<c-G>U<left>') k({'c','t'},'「','「」<left>') k({'i','c','t'},'<leader>「','「')
k('i','『','『』<c-G>U<left>') k({'c','t'},'『','『』<left>') k({'i','c','t'},'<leader>『','『')
k('i','【','【】<c-G>U<left>') k({'c','t'},'【','【】<left>') k({'i','c','t'},'<leader>【','【')

k('i','<c-b>','()<c-g>U<left>') k({'c','t'},'<c-b>','()<left>') -- Bracket scheme用
k('i','<c-d>','""<c-g>U<left>') k({'c','t'},'<c-d>','"<left>"') -- Double quote
