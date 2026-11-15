return {
    lazy = false,
    runtimePackages = {
        "git",
    },
    after = function()
        -- TODO: Properly set this up
        require("mini.statusline").setup()

        require("mini.move").setup({
            mappings = {
                left = "<S-h>",
                right = "<S-l>",
                down = "<S-j>",
                up = "<S-k>",
            },
        })

        require('mini.statuscolumn').setup()
        require('mini.git').setup()
        require('mini.diff').setup({
            view = {
                style = 'sign',
                signs = { add = '┃', change = '┃', delete = '_' },
            },
        })
        -- TODO: Figure out how to disable animation
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

        require("mini.icons").setup()

        local hipatterns = require("mini.hipatterns")
        hipatterns.setup({
            highlighters = {
                -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
                hack = { pattern = "%f[%w]()HACK()%f[%W]", group = "MiniHipatternsHack" },
                todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsTodo" },
                note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },

                -- Highlight hex color strings (`#rrggbb`) using that color
                hex_color = hipatterns.gen_highlighter.hex_color(),
            },
        })
    end,
}
