local M = {}

-- 翻訳版を編集しているとき、公式ヘルプを開く
function M.translate(opts)
    local doc_dir,doc_name = opts.dir,opts.name

    -- カーソル位置の保存
    local pos = vim.api.nvim_win_get_cursor(0)
    local topline = vim.fn.line("w0")

    local original_doc_path = doc_dir .. "/" .. doc_name .. ".txt"
    local original_doc_path = vim.fs.joinpath(doc_dir,doc_name) .. ".txt"
    vim.tbl_map(function(w)
        vim.wo[w].scrollbind = false
    end,vim.api.nvim_list_wins())
    vim.cmd.vsplit(original_doc_path)
    vim.o.buflisted = false
    vim.o.scrollbind = true

    -- カーソル位置の復元
    vim.fn.feedkeys(topline .. "Gzt","n")
    vim.schedule(function()
        vim.api.nvim_win_set_cursor(0,pos)
        vim.cmd.wincmd("l")
        vim.o.scrollbind = true
    end) -- schedule しないとカーソルが移動しない
end

return M
