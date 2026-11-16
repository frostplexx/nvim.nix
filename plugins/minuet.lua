local codestral_api_key
local warned_missing_key = false

local function secretspec_args(...)
    local args = { 'secretspec', ... }
    local manifest = vim.api.nvim_get_runtime_file('secretspec.toml', false)[1]
    if manifest then
        vim.list_extend(args, { '--file', manifest })
    end
    return args
end

local function resolve_codestral_api_key()
    if codestral_api_key then
        return codestral_api_key
    end
    local key = vim.fn.system(secretspec_args('get', 'CODESTRAL_API_KEY'))
    if vim.v.shell_error ~= 0 then
        if not warned_missing_key then
            warned_missing_key = true
            vim.notify(
                'minuet: CODESTRAL_API_KEY unresolved, run `:MinuetSetApiKey`',
                vim.log.levels.WARN
            )
        end
        return nil
    end
    codestral_api_key = vim.trim(key)
    return codestral_api_key
end

return {
    event = 'InsertEnter',
    cmd = { 'MinuetSetApiKey' },
    after = function()
        vim.api.nvim_create_user_command('MinuetSetApiKey', function()
            local key = vim.fn.inputsecret 'Codestral API key: '
            if key == '' then
                return
            end
            local output = vim.fn.system(secretspec_args('set', 'CODESTRAL_API_KEY', '--from-file', '-'), key)
            if vim.v.shell_error ~= 0 then
                vim.notify('minuet: secretspec set failed: ' .. output, vim.log.levels.ERROR)
                return
            end
            codestral_api_key = key
            warned_missing_key = false
            vim.notify('minuet: CODESTRAL_API_KEY stored', vim.log.levels.INFO)
        end, { desc = 'Store the minuet Codestral API key via secretspec' })

        require('minuet').setup {
            provider_options = {
                codestral = { api_key = resolve_codestral_api_key },
            },
            virtualtext = {
                auto_trigger_ft = {"*"},
                keymap = {
                    -- accept whole completion
                    accept = '<C-cr>',
                    -- accept one line
                    accept_line = '<A-a>',
                    -- accept n lines (prompts for number)
                    -- e.g. "A-z 2 CR" will accept 2 lines
                    accept_n_lines = '<A-z>',
                    -- Cycle to prev completion item, or manually invoke completion
                    prev = '<A-[>',
                    -- Cycle to next completion item, or manually invoke completion
                    next = '<A-]>',
                    dismiss = '<A-e>',
                },
                show_on_completion_menu = true,
            },
        }
    end
}
