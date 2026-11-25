return {
  cmd = "Yazi",
  -- This gets read by nix to determine which packages to install for the plugin to work.
  runtimePackages = {
    "yazi",
  },
  keys = {
    { "<leader>e", "<cmd>Yazi<cr>", desc = "Open Yazi" },
  },
  after = function()
    -- macOS default is Homebrew `grealpath`; use the system `realpath` instead.
    require("yazi").config.integrations.resolve_relative_path_application = "realpath"
  end,
}
