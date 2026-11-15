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
      format_on_save = {
        timeout_ms = 500,
        lsp_format = "fallback",
      },
    }
  end,
}
