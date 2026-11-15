return {
    lazy = false,
    setup = false,
    runtimePackages = {
        "git",
    },
    after = function()
        -- TODO: Properly set this up
        require("mini.statusline").setup({
            content = {
                active = function()
                    local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = math.huge })
                    local git = MiniStatusline.section_git({ trunc_width = 40 })
                    local diff = MiniStatusline.section_diff({ trunc_width = 75 })
                    local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
                    local filename = MiniStatusline.section_filename({ trunc_width = 140 })
                    local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = math.huge })
                    local location = MiniStatusline.section_location({ trunc_width = 75 })

                    local clients = vim.lsp.get_clients({ bufnr = 0 })
                    local lsp = ""
                    if #clients > 0 then
                        local names = {}
                        for _, client in ipairs(clients) do
                            names[#names + 1] = client.name
                        end
                        lsp = "󰰎 " .. table.concat(names, " ")
                    end

                    return MiniStatusline.combine_groups({
                        { hl = mode_hl, strings = { mode } },
                        { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics, lsp } },
                        "%<",
                        { hl = "MiniStatuslineFilename", strings = { filename } },
                        "%=",
                        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
                        { hl = mode_hl, strings = { location } },
                    })
                end,
            },
        })

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
