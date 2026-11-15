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

                    local git = MiniStatusline.section_git({ trunc_width = 40, icon = "•" })
                    local diff = MiniStatusline.section_diff({ trunc_width = 75 })
                    local diagnostics = MiniStatusline.section_diagnostics({
                        trunc_width = 75,
                        icon = "",
                        signs = { ERROR = "󰅙", WARN = "", INFO = "", HINT = "󰌵" },
                    })

                    local clients = vim.lsp.get_clients({ bufnr = 0 })
                    local lsp = ""
                    if #clients > 0 then
                        local names = {}
                        for _, client in ipairs(clients) do
                            names[#names + 1] = client.name
                        end
                        lsp = " " .. table.concat(names, ", ")
                    end

                    local filetype_icon = require("mini.icons").get("filetype", vim.bo.filetype)
                    local filename = "%t%m%r"

                    local progress = math.floor(vim.fn.line(".") / math.max(1, vim.fn.line("$")) * 100) .. "%%"
                    local time = os.date("%H:%M")
                    local fileformat = ({ unix = "", dos = "", mac = "" })[vim.bo.fileformat] or ""

                    return MiniStatusline.combine_groups({
                        { hl = mode_hl, strings = { mode } },
                        { hl = "MiniStatuslineDevinfo", strings = { filetype_icon, filename } },
                        "%<",
                        { hl = "MiniStatuslineFilename", strings = { diff } },
                        "%=",
                        { hl = "MiniStatuslineDevinfo", strings = { lsp, diagnostics } },
                        { hl = "MiniStatuslineFileinfo", strings = { git, progress, time, fileformat } },
                    })
                end,
            },
        })

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
            items = {
                { name = " ", action = "", section = "" },
            },
            footer = "",
            content_hooks = {
                require("mini.starter").gen_hook.aligning("center", "center"),
            },
        })

        local starter_cursor_hl
        local starter_guicursor

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "ministarter",
            callback = function()
                starter_cursor_hl = vim.api.nvim_get_hl(0, { name = "Cursor", link = false })
                starter_guicursor = vim.o.guicursor
                vim.api.nvim_set_hl(0, "Cursor", { blend = 100, fg = starter_cursor_hl.fg, bg = starter_cursor_hl.bg })
                vim.o.guicursor = starter_guicursor .. ",a:Cursor/lCursor"
            end,
        })

        vim.api.nvim_create_autocmd({ "BufLeave", "BufEnter" }, {
            callback = function()
                if vim.bo.filetype == "ministarter" or not starter_cursor_hl then
                    return
                end
                vim.api.nvim_set_hl(0, "Cursor", starter_cursor_hl)
                vim.o.guicursor = starter_guicursor
                starter_cursor_hl = nil
            end,
        })

        require("mini.move").setup({
            mappings = {
                left = "<S-h>",
                right = "<S-l>",
                down = "<S-j>",
                up = "<S-k>",
                line_left = "",
                line_right = "",
                line_down = "",
                line_up = "",
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

        local function set_statusline_highlights()
            vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "NONE" })
            local inactive = vim.api.nvim_get_hl(0, { name = "MiniStatuslineInactive" })
            vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = inactive.fg, bg = "NONE" })
        end
        set_statusline_highlights()
        vim.api.nvim_create_autocmd("ColorScheme", { callback = set_statusline_highlights })

        require("mini.icons").setup()
        require("mini.align").setup()
        require("mini.bufremove").setup()

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
