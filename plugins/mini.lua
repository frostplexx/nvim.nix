return {
    after = function()
        -- TODO: Properly set this up
        require('mini.statusline').setup()


        require('mini.move').setup({
            mappings = {
                left = "<S-h>",
                right = "<S-l>",
                down = "<S-j>",
                up = "<S-k>",
            },
        })

        require('mini.statuscolumn').setup()

        -- TODO: Figure out how to disable animation
        local indentscope = require('mini.indentscope')
        indentscope.setup({
            delay = 0,
            animation = function()
                return indentscope.gen_animation.none()
            end,
            symbol = '│',
        })

        require('mini.icons').setup()

        local hipatterns = require('mini.hipatterns')
        hipatterns.setup({
            highlighters = {
                -- Highlight standalone 'FIXME', 'HACK', 'TODO', 'NOTE'
                fixme     = { pattern = '%f[%w]()FIXME()%f[%W]', group = 'MiniHipatternsFixme' },
                hack      = { pattern = '%f[%w]()HACK()%f[%W]', group = 'MiniHipatternsHack' },
                todo      = { pattern = '%f[%w]()TODO()%f[%W]', group = 'MiniHipatternsTodo' },
                note      = { pattern = '%f[%w]()NOTE()%f[%W]', group = 'MiniHipatternsNote' },

                -- Highlight hex color strings (`#rrggbb`) using that color
                hex_color = hipatterns.gen_highlighter.hex_color(),
            },
        })
    end
}
