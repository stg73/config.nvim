local M = {}

function M.setup()
    local ui2 = require("vim._core.ui2")

    vim.o.cmdheight = 0
    ui2.enable({
        enable = true,
        msg = {
            target = "msg",
            timeout = 2000
        }
    })

    local group = vim.api.nvim_create_augroup("show-recording-message",{})
    vim.api.nvim_create_autocmd("RecordingEnter",{
        group = group,
        nested = true, -- [[\vrecording \@.]] の表示を出す
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

    -- tOggle
    vim.keymap.set("n","<leader>o",function()
        vim.o.cmdheight = vim.o.cmdheight == 0 and 1 or 0
    end)

    -- ui2のblendをset_hlできるようにする
    vim.api.nvim_create_autocmd("FileType",{
        group = vim.api.nvim_create_augroup("winblend",{}),
        pattern = {"msg","pager"},
        callback = function()
            vim.wo.winblend = 1
        end,
    })

    -- CmdWinLeave 時にウィンドウが表示されてしまうので、修正する
    local function is_ui2_autocmd(tbl)
        return tbl.desc == "Hide or reposition pager window."
    end
    local t = require("tbl")
    vim.api.nvim_create_autocmd("CmdWinLeave",{
        callback = function()
            t.pipe({
                vim.api.nvim_get_autocmds({ event = "CmdWinLeave" }),
                t.filter(is_ui2_autocmd),
                t.map(t.get("id")),
                t.map(vim.api.nvim_del_autocmd),
            })
        end,
    })
end

return M
