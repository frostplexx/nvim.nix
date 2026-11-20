return {
    lazy = false,
    setup = false,
    after = function()
        require("fff").setup({
            debug = {
                enabled = true,
                show_scores = true,
            },
        })
    end,
}
