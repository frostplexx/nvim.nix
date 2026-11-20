return function()
    require("mini.starter").setup({
        header = function()
            local version = vim.api.nvim_exec2("version", { output = true }).output:match("NVIM ([^\n]+)")
            local lines = {
                "│ ╲ ││",
                "││╲╲││",
                "││ ╲ │",
                "",
                "NVIM " .. (version or tostring(vim.version())),
            }
            local width = 0
            for _, line in ipairs(lines) do
                width = math.max(width, vim.fn.strdisplaywidth(line))
            end
            for i, line in ipairs(lines) do
                local pad = math.floor((width - vim.fn.strdisplaywidth(line)) / 2)
                lines[i] = string.rep(" ", pad) .. line
            end
            return table.concat(lines, "\n")
        end,
        items = require('mini.starter').sections.builtin_actions(),
        footer = "",
        content_hooks = {
            require("mini.starter").gen_hook.aligning("center", "center"),
        },
        silent = true,
    })
end
