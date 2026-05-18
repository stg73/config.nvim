local nvim = {}

local topics = {
    "win",
    "buf",
    "tabpage",
}

for _name,fn in pairs(vim.api) do
    local name = regex.remove("^nvim_")(_name)
    local s,e = regex.find("^(" .. table.concat(topics,"|") .. ")")(name)
    if s and e then
        local topic,rest = string.sub(name,s,e),string.sub(name,e + 2)
        nvim[topic] = nvim[topic] or {}
        nvim[topic][rest] = fn
    else
        nvim[name] = fn
    end
end

return nvim
