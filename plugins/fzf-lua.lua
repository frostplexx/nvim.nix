return {
  runtimePackages = {
    "fzf",
    "ripgrep",
    "fd",
  },
  keys = {
    { "<leader>f", function() require("fzf-lua").files() end, desc = "Find files" },
    { "<leader>F", function() require("fzf-lua").live_grep() end, desc = "Live grep" },
  },
}
