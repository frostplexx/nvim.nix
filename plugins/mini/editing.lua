return function()
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

    require("mini.align").setup()
    require("mini.bufremove").setup()
end
