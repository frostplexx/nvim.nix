local codestral_api_key
local warned_missing_key = false

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

local function is_completable_buffer()
    return vim.bo.buftype == '' and not vim.tbl_contains(skip_filetypes, vim.bo.filetype)
end

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
    event = 'BufEnter',
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
            enable_predicates = { is_completable_buffer },
            provider_options = {
                codestral = {
                    model = 'codestral-2508',
                    api_key = resolve_codestral_api_key,
                },
            },
        }
    end
}
