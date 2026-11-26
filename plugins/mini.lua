return {
    lazy = false,
    setup = false,
    runtimePackages = {
        "git",
        "fortune",
        "ripgrep",
        "fd",
    },
    after = function()
        local config_dir = vim.fn.stdpath("config")
        local nix_config_dir = _G.nixInfo and _G.nixInfo(nil, "settings", "config_directory")
        if nix_config_dir then config_dir = nix_config_dir end

        local function setup(name)
            dofile(config_dir .. "/plugins/mini/" .. name .. ".lua")()
        end


        setup("statusline")
        setup("starter")
        setup("statuscolumn")
        setup("indentscope")
        setup("icons")
        setup("picker")
        setup("sessions")

        -- Not needed for the first paint, so keep them off the startup path.
        vim.schedule(function()
            setup("editing")
            setup("git")
            setup("hipatterns")
        end)
    end,
}
