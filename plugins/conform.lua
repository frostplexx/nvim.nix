return {
  lazy = false,
  setup = false,
  runtimePackages = {
    "black",
    "clang-tools",
    "gofumpt",
    "nixfmt",
    "prettier",
    "rustfmt",
    "shfmt",
    "stylua",
    "taplo",
    "yamlfmt",
  },
  after = function()
    require("conform").setup {
      formatters = {
        stylua = {
          prepend_args = { "--indent-type", "Spaces", "--indent-width", "4" },
        },
      },
      formatters_by_ft = {
        bash = { "shfmt" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        css = { "prettier" },
        go = { "gofumpt" },
        html = { "prettier" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        nix = { "nixfmt" },
        python = { "black" },
        rust = { "rustfmt" },
        sh = { "shfmt" },
        toml = { "taplo" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
      },
    }

    vim.keymap.set({ "n", "v" }, "<leader>lf", function()
      require("conform").format({ async = true, lsp_format = "fallback" })
    end, { desc = "Format buffer" })
  end,
}
