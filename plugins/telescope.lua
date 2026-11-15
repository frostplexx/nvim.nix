return {
  runtimePackages = {
    "ripgrep",
    "fd",
  },
  keys = {
    { "<leader>f", "<cmd>Telescope find_files<cr>", desc = "Find files" },
  },
}
