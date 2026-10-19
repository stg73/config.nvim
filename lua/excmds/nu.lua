local M = {}

function M.extern_flag(opts)
    vim.cmd.substitute({ range = { opts.line1, opts.line2 }, [[/\v(..), (\S+) \<(.+)\> +(.+)/\2(\1):\3, # \4]]})
end

function M.extern_command(opts)
    vim.cmd.substitute({
        range = { opts.line1, opts.line2 },
        [[/\v^ *(\S+) +(.+)/# \2\rextern "]] .. (opts.args ~= "" and (opts.args .. " ") or "") .. [[\1" [\r]\r]]
    })
end

return M
