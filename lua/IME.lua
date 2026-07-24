local M = {}

-- 参考にしたもの: https://qiita.com/kenichiro_ayaki/items/d55005df2787da725c6f
local ffi = require"ffi"
c = ffi.C

ffi.cdef [[
// #if defined(_WIN64)
 // typedef __int64 LONG_PTR;
// #else
 typedef long LONG_PTR;
// #endif

// #if defined(_WIN64)
 // typedef unsigned __int64 UINT_PTR;
// #else
 typedef unsigned int UINT_PTR;
// #endif

typedef unsigned int UINT;
typedef UINT_PTR WPARAM;
typedef LONG_PTR LPARAM;
typedef LONG_PTR LRESULT;
typedef unsigned int HWND;

LRESULT SendMessageW(
  HWND   hWnd,
  UINT   Msg,
  WPARAM wParam,
  LPARAM lParam
);
HWND GetForegroundWindow();
UINT ImmGetDefaultIMEWnd(HWND hwnd);
]]

local imm32 = ffi.load("imm32")
M._request = function(op,val)
    local im = imm32.ImmGetDefaultIMEWnd(c.GetForegroundWindow())
    return c.SendMessageW(im,0x0283,op,val)
end

M.is_enabled = function()
    return M._request(5,0) == 1
end

M.enable = function(enable)
    enable = enable == nil and true or enable
    return M._request(6,enable and 1 or 0) == 0
end

local modes = {
    hiragana = 25,
    ascii = 0,
    zennkaku = 8,
    hannkaku = 19,
    katakana = 27,
}

local get_idx = function(v,t)
    for k,_v in pairs(t) do
        if _v == v then
            return k
        end
    end
end

M.get_mode = function()
    return get_idx(M._request(0x001,0),modes)
end

M.set_mode = function(mode)
    M._request(0x002,modes[mode])
end

return M
