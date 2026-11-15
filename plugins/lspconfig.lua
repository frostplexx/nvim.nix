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

    vim.lsp.inlay_hint.enable(true)

    local map = vim.keymap.set
    map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
    map("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
    map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
    map("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
    map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })
    map("n", "<leader>lk", vim.lsp.buf.signature_help, { desc = "Signature help" })
    map("n", "<leader>ls", vim.lsp.buf.document_symbol, { desc = "Document symbols" })
    map("n", "<leader>li", vim.lsp.buf.implementation, { desc = "Implementations" })
    map("n", "<leader>lr", vim.lsp.buf.references, { desc = "References" })
    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, { desc = "Next diagnostic" })
    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, { desc = "Previous diagnostic" })
    map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Diagnostic float" })
    map("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })

    map({ "n", "v" }, "<leader>lf", function()
      vim.lsp.buf.format({ async = true })
    end, { desc = "Format buffer" })
  end,
}
