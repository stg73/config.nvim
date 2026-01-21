local M = {}

-- "、|hoge|"のような文字列があった場合、treesitterでは"|hoge|"がハイライトされない
-- そのような文字列を検索する
function M.grep_highlight_errors(opts)
    vim.cmd.vimgrep([[/\v[^ \t.(`]\|[!-~]{-}\|/g]],opts.args ~= "" and opts.args or "*")
end

-- 翻訳版を編集しているとき、公式ヘルプを開く
function M.edit_original(opts)
    -- カーソル位置の保存
    local pos = vim.api.nvim_win_get_cursor(0)
    local topline = vim.fn.line("w0")

    local doc_name = opts.args ~= "" and opts.args or vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0),":t:r")
    local original_doc_path = vim.env.VIMRUNTIME .. "/doc/" .. doc_name .. ".txt"
    vim.cmd.vsplit(original_doc_path)

    -- カーソル位置の復元
    vim.fn.feedkeys(topline .. "Gzt","n")
    vim.schedule(function() vim.api.nvim_win_set_cursor(0,pos) end) -- schedule しないとカーソルが移動しない
end

return M
