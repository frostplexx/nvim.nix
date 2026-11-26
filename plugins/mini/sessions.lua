return function()
        require("mini.sessions").setup({
            directory = vim.fn.stdpath("state") .. "/sessions",
        })
end
