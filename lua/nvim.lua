local nvim = {}

local api_words = {
    "win",
    "buf",
    "tabpage",
    "current",
    "create",
    "del",
    "get",
    "set",
    "list",
    "call",
    "parse",
    "open",
    "is",
}

local function parse_name(pattern) return function(name)
    local t = {}
    local function loop(str)
        local s,e = regex.find("^(" .. pattern ..  ")_")(str)
        if s then
            local x,y = string.sub(str,s,e - 1),string.sub(str,e + 1)
            table.insert(t,x)
            if y ~= "" then
                return loop(y)
            end
        else
            table.insert(t,str)
        end
    end
    loop(name)
    return t
end end
local parse_api_name = parse_name(table.concat(api_words,"|"))

local function set_table(tbl,list)
    local function loop(i,t)
        local is_key = list[i + 1] ~= nil
        if is_key then
            local is_table = list[i + 2] ~= nil
            if is_table then
                if not t[list[i]] then
                    t[list[i]] = {}
                end
                return loop(i + 1,t[list[i]])
            else
                return loop(i + 1,t)
            end
        else
            t[list[i - 1]] = list[i]
        end
    end

    loop(1,tbl)
end

for name,fn in pairs(vim.api) do
    local parsed = parse_api_name(regex.remove("nvim_")(name))
    table.insert(parsed,fn)
    set_table(nvim,parsed)
end

return nvim
