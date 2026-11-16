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
            },
            fzf_colors = {
                ["bg"] = "-1",
                ["bg+"] = "-1",
                ["gutter"] = "-1",
            },
        })
        require("fzf-lua").register_ui_select()
    end
}
