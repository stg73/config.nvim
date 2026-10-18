local ui2 = require("vim._core.ui2")

vim.o.cmdheight = 0
if vim.fn.has "nvim-0.13" == 1 then
    ui2.enable {
        enable = true,
        msg = {
            targets = "msg",
        }
    }
    vim.opt.messagesopt:append { timeout = 2000 }
else
    ui2.enable {
        enable = true,
        msg = {
            targets = "msg",
            timeout = 2000,
        }
    }
end

local group = vim.api.nvim_create_augroup("show-recording-message",{})
vim.api.nvim_create_autocmd("RecordingEnter",{
    group = group,
    nested = true, -- ui2にオプションを反映する
    callback = function()
        vim.o.cmdheight = 1
    end,
})
vim.api.nvim_create_autocmd("RecordingLeave",{
    group = group,
    nested = true, -- ui2にオプションを反映する
    callback = function()
        vim.o.cmdheight = 0
    end,
})

-- ui2のblendをset_hlできるようにする
vim.api.nvim_create_autocmd("FileType",{
    group = vim.api.nvim_create_augroup("winblend",{}),
    pattern = {"msg","pager"},
    callback = function()
        vim.wo.winblend = 1
    end,
})
