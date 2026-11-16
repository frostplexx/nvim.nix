return {
  lazy = false,
  setup = false,
  runtimePackages = {
    "deadnix",
    "eslint",
    "fish",
    "golangci-lint",
    "jq",
    "markdownlint-cli",
    "ruff",
    "selene",
    "shellcheck",
    "statix",
    "yamllint",
  },
  after = function()
    require("lint").linters_by_ft = {
      bash = { "shellcheck" },
      fish = { "fish" },
      go = { "golangcilint" },
      javascript = { "eslint" },
      javascriptreact = { "eslint" },
      json = { "jq" },
      lua = { "selene" },
      markdown = { "markdownlint" },
      nix = { "statix", "deadnix" },
      python = { "ruff" },
      sh = { "shellcheck" },
      typescript = { "eslint" },
      typescriptreact = { "eslint" },
      yaml = { "yamllint" },
    }

    vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
