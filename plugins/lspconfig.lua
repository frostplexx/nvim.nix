return {
  lazy = false,
  setup = false,
  runtimePackages = {
    "bash-language-server",
    "cargo",
    "clang-tools",
    "fish-lsp",
    "go",
    "gopls",
    "just-lsp",
    "lua-language-server",
    "marksman",
    "nixd",
    "pyright",
    "rust-analyzer",
    "rustc",
    "rustfmt",
    "typescript-language-server",
    "vscode-css-languageserver",
    "vscode-html-languageserver",
    "vscode-json-languageserver",
    "yaml-language-server",
  },
  after = function()
    vim.lsp.enable({
      "bashls",
      "clangd",
      "cssls",
      "fish_lsp",
      "gopls",
      "html",
      "jsonls",
      "just",
      "lua_ls",
      "marksman",
      "nixd",
      "pyright",
      "rust_analyzer",
      "ts_ls",
      "yamlls",
    })

    vim.keymap.set({ "n", "v" }, "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format buffer" })
  end,
}
