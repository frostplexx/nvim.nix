return {
    cmd = "Copilot",
    event = "InsertEnter",
    setup = false,
    after = function()
        require('copilot').setup({
            panel = {
                enabled = false,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = false,
                keymap = {
                    accept = "<C-cr>",
                },
            }
        })
    end
}
