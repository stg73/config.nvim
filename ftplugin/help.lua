-- txt 以外のヘルプを編集する際に CTRL-] が使えるように
local lang = vim.api.nvim_buf_get_name(0):match("(..)x$")
if lang then
    vim.bo.tags = vim.o.tags .. ",tags-" .. lang
end
