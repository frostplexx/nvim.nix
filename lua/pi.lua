local rex = require("rex")

local M = {}

local t = "com.superlogical.terminal"

-- Returns the block running pi, skipping the one Neovim runs in.
local function find_pi()
    for _, b in ipairs(rex.session.list_blocks {}.blocks) do
        if b.creator_name == t and b.block_id ~= vim.env.REX_BLOCK then
            local p = rex.block.call(t, "process", { block_id = b.block_id })
            local fg = p and p.foreground
            if fg and (fg.name == "pi" or fg.argv0 == "pi") then
                return b.block_id
            end
        end
    end
end

local function send_text(text)
    local pi_block = find_pi()
    if not pi_block then
        return vim.notify("Pi is not running", vim.log.levels.WARN)
    end
    return rex.block.call(t, "write", { block_id = pi_block, data = text })
end

-- Opens a float.
local function prompt_buffer(on_confirm)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"

    local width = math.max(40, math.floor(vim.o.columns * 0.6))
    local height = math.max(5, math.floor(vim.o.lines * 0.25))
    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " Prompt  <C-s> send  <Esc> cancel ",
        title_pos = "center",
    })

    local answered = false

    local function finish(value)
        if answered then
            return
        end
        answered = true
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
        if vim.api.nvim_buf_is_valid(buf) then
            vim.api.nvim_buf_delete(buf, { force = true })
        end
        on_confirm(value)
    end

    vim.keymap.set({ "n", "i" }, "<C-s>", function()
        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        finish(table.concat(lines, "\n"))
    end, { buffer = buf, desc = "Send prompt to pi" })

    vim.keymap.set({ "n", "i" }, "<Esc>", function()
        finish(nil)
    end, { buffer = buf, desc = "Cancel prompt" })

    vim.cmd("startinsert")
end

-- on_confirm gets nil when the user cancels.
local function ask_prompt(on_confirm)
    return prompt_buffer(on_confirm)
end

-- Sends prefix, then the prompt. A cancelled prompt sends nothing.
local function submit(prefix)
    ask_prompt(function(prompt)
        if prompt == nil then
            return
        end
        local text = prompt
        if prefix and prefix ~= "" then
            text = prefix .. "\n" .. prompt
        end
        -- "\r" is Enter and submits the message.
        send_text(text .. "\r")
    end)
end

function M.send_selected_text()
    submit(vim.fn.getreg('"'))
end

function M.send_buffer()
    submit("@" .. vim.fn.expand('%:p'))
end

function M.talk_to_pi()
    submit(nil)
end

return M
