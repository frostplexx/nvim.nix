return {
    runtimePackages = {
        "fzf",
        "ripgrep",
        "fd",
    },
    keys = {
        { "<leader>f", function() require("fzf-lua").files() end,     desc = "Find files" },
        { "<leader>F", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
    },

    after = function()
        require("fzf-lua").setup({
            "telescope",
            winopts = {
                backdrop = 100,
                preview = {
                    border = "rounded",
                    winopts = {
                        winhl = {
                            Normal = "Normal",
                            NormalFloat = "Normal",
                            FloatBorder = "FloatBorder",
                        },
                    },
                },
            },
            hls = {
                normal = "Normal",
                preview_normal = "Normal",
                help_normal = "Normal",
                border = "FloatBorder",
                preview_border = "FloatBorder",
            },
            fzf_colors = {
                ["bg"] = "-1",
                ["bg+"] = "-1",
                ["gutter"] = "-1",
            },
        })
    end
}
