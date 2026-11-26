-- Completion is pointless in these buffers and costs a request per keystroke.
local skip_filetypes = {
    'help',
    'fzf',
    'lazy',
    'mason',
    'minifiles',
    'NvimTree',
    'oil',
    'TelescopePrompt',
    'Yazi',
}

return {
    event = 'InsertEnter',
    cmd = { 'Copilot' },
    -- copilot.lua ignores a second setup() call, so run it only here.
    setup = false,
    after = function()
        require('copilot').setup {
            -- Suggestions are rendered by blink-copilot through blink.cmp.
            suggestion = { enabled = false },
            panel = { enabled = false },
            filetypes = { ['*'] = true },
            should_attach = function(bufnr)
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                return vim.bo[bufnr].buftype == ''
                    and not vim.tbl_contains(skip_filetypes, vim.bo[bufnr].filetype)
                    and not bufname:match '%.env'
            end,
        }
    end,
}
