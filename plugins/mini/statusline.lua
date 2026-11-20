return function()
    require("mini.statusline").setup({
        content = {
            active = function()
                local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = math.huge })

                local git           = MiniStatusline.section_git({ trunc_width = 40 })
                local diagnostics   = MiniStatusline.section_diagnostics({
                    trunc_width = 75,
                    icon = "",
                    signs = { ERROR = "󰅙", WARN = "", INFO = "", HINT = "󰌵" },
                })

                local clients       = vim.lsp.get_clients({ bufnr = 0 })
                local lsp           = ""
                if #clients > 0 then
                    local names = {}
                    for _, client in ipairs(clients) do
                        names[#names + 1] = client.name
                    end
                    lsp = "  [" .. table.concat(names, ", ") .. "]"
                end

                local search        = MiniStatusline.section_searchcount({ trunc_width = 75 })

                local filetype_icon = require("mini.icons").get("filetype", vim.bo.filetype)
                local filename      = "%t%m%r"
                local location      = MiniStatusline.section_location({ trunc_width = 75 })

                local progress      = math.floor(vim.fn.line(".") / math.max(1, vim.fn.line("$")) * 100) .. "%%"

                return MiniStatusline.combine_groups({
                    { hl = mode_hl,                 strings = { mode } },
                    { hl = "MiniStatuslineDevinfo", strings = { git, filetype_icon, filename, } },
                    "%<",
                    { hl = "MiniStatuslineFilename", strings = { " " } },
                    "%=",
                    { hl = "MiniStatuslineFilename", strings = { search, diagnostics } },
                    "%=",
                    { hl = "MiniStatuslineDevinfo",  strings = { lsp } },
                    { hl = "MiniStatuslineFileinfo", strings = { progress, location } },
                })
            end,
        },
    })

    local function set_statusline_highlights()
        vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "NONE" })
        local inactive = vim.api.nvim_get_hl(0, { name = "MiniStatuslineInactive" })
        vim.api.nvim_set_hl(0, "MiniStatuslineInactive", { fg = inactive.fg, bg = "NONE" })
    end
    set_statusline_highlights()
    vim.api.nvim_create_autocmd("ColorScheme", { callback = set_statusline_highlights })
end
