return {
    lazy = false,
    setup = false,
    after = function()
        require("blink.pairs").setup {
            mappings = {
                enabled = false, -- disable autopair functionality
            }
        }
    end,
}
