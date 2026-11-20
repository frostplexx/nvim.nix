return function()
    local indentscope = require("mini.indentscope")
    indentscope.setup({
        draw = {
            delay = 0,
            animation = indentscope.gen_animation.none(),
        },
        symbol = "│",
    })

    local function set_indent_highlights()
        vim.api.nvim_set_hl(0, "MiniIndentscopeSymbol", { fg = "#585b70" })
        vim.api.nvim_set_hl(0, "MiniIndentscopeSymbolOff", { fg = "#313244" })
    end
    set_indent_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_indent_highlights })
end
