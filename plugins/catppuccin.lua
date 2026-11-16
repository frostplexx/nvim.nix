return {
    lazy = false,
    after = function()
        require("catppuccin").setup({
            flavour = "mocha", -- latte, frappe, macchiato, mocha
            background = {     -- :h background
                light = "latte",
                dark = "mocha",
            },
            transparent_background = true,
            float = {
                transparent = true,
            },
            show_end_of_buffer = false, -- show the '~' characters after the end of buffers
            term_colors = false,
            dim_inactive = {
                enabled = false,
                shade = "dark",
                percentage = 0.15,
            },
            no_italic = false, -- Force no italic
            no_bold = false,   -- Force no bold
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = {},
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            color_overrides = {},
            custom_highlights = {},
            -- Integration detection walks the whole runtimepath on every start;
            -- the list below is explicit instead.
            auto_integrations = false,
            integrations = {
                blink_cmp = {
                    style = 'rounded',
                },

                render_markdown = true,
                fzf = true,
                mini = {
                    enabled = true,
                    indentscope_color = "",
                },
            },
        })
        vim.cmd.colorscheme("catppuccin")
    end,
}
