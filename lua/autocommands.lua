-- Resume session in rex
local token = vim.env.OSC7577_TOKEN
vim.env.OSC7577_TOKEN = nil


-- Rex drops the record when the owning process exits, so save while alive
-- and not only at VimLeavePre.
local function save_session()
    local dir = vim.fn.stdpath("state") .. "/sessions"
    vim.fn.mkdir(dir, "p")
    -- One file per running instance, so two Neovims do not overwrite each other
    vim.v.this_session = ("%s/%d.vim"):format(dir, vim.uv.os_getppid())
    vim.cmd("mksession! " .. vim.fn.fnameescape(vim.v.this_session))
end

vim.api.nvim_create_autocmd("SessionWritePost", {
    callback = function()
        if not token then return end
        local argv = { "nvim", "-S", vim.v.this_session }
        for i, arg in ipairs(argv) do 
            argv[i] = vim.base64.encode(arg) 
        end
        -- This process is Neovim's server. The terminal runs its parent, the TUI
        local body = ("pid=%d:time=%d:argv=%s"):format(
            vim.uv.os_getppid(), os.time(), table.concat(argv, ",")
        )

        local mac = vim.fn.sha256(body .. ":" .. token)
        io.stderr:write("\27]7577;", body, ":mac=", mac, "\27\\")
    end,
})

vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
        if token then vim.schedule(save_session) end
    end,
})

local last_save = 0
vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
    callback = function()
        if not token then return end
        if os.time() - last_save < 15 then return end
        last_save = os.time()
        vim.schedule(function()
            local ok, err = pcall(save_session)
            if not ok then vim.notify("session save failed: " .. err, vim.log.levels.WARN) end
        end)
    end,
})
