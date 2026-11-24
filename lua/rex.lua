-- Neovim-side `rex` table, backed by the `rex` CLI.
-- Rex injects `rex` only into its own Lua VM, so calls here spawn a process.
local M = {}

local bin = vim.env.REX_BIN or "rex"
local session_id = vim.env.REX_SESSION
local block_id = vim.env.REX_BLOCK

local function invoke(method, args)
    local cmd = { bin, "api", "call" }
    if session_id and session_id ~= "" then
        vim.list_extend(cmd, { "-s", session_id })
    end
    vim.list_extend(cmd, { method, vim.json.encode(args or {}) })

    local ok, proc = pcall(vim.system, cmd, { text = true })
    if not ok then
        return nil, "vim.system failed"
    end
    local res = proc:wait(10000)
    if res.code ~= 0 then
        return nil, vim.trim(res.stderr)
    end
    local good, decoded = pcall(vim.json.decode, res.stdout)
    if not good then
        return nil, "bad JSON: " .. res.stdout
    end
    return decoded
end

function M.call(method, args)
    return invoke(method, args)
end

M.session = setmetatable({}, {
    __index = function(_, name)
        return function(args)
            return invoke("session." .. name, vim.tbl_extend("force", { session_id = session_id }, args or {}))
        end
    end,
})

M.block = {
    call = function(creator, method, args)
        local a = vim.deepcopy(args or {})
        local id = a.block_id or block_id
        a.block_id = nil
        -- An empty Lua table encodes as [], which the server rejects.
        if next(a) == nil then
            a = vim.empty_dict()
        end
        return invoke(creator .. "." .. method, { block_id = id, args = a })
    end,
}

return M
