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
    "nil",
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
      "nil_ls",
      "pyright",
      "rust_analyzer",
      "ts_ls",
      "yamlls",
    })

    local frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    local frame = 0
    local active = {}
    local seq = 0
    local message_id = "lsp-progress"
    local timer = vim.uv.new_timer()

    local function current()
      local best
      for _, item in pairs(active) do
        if not best or item.seq > best.seq then
          best = item
        end
      end
      return best
    end

    local function render()
      local item = current()
      if not item then
        return
      end

      frame = (frame % #frames) + 1
      vim.api.nvim_echo({ { item.title } }, false, {
        id = message_id,
        kind = "progress",
        status = "running",
        percent = item.percent,
        title = frames[frame] .. " LSP",
        source = "lsp-progress",
      })
    end

    local function ensure_timer()
      if not timer:is_active() then
        timer:start(0, 80, vim.schedule_wrap(render))
      end
    end

    vim.api.nvim_create_autocmd("LspProgress", {
      callback = function(event)
        local data = event.data
        local params = data.params
        local value = params.value
        if value == nil then
          return
        end

        local id = ("%s:%s"):format(data.client_id, tostring(params.token))
        local item = active[id]

        if value.kind == "end" then
          active[id] = nil
        else
          seq = seq + 1
          active[id] = {
            title = value.title or (item and item.title) or "LSP",
            percent = value.percentage or (item and item.percent),
            seq = seq,
          }
        end

        if next(active) then
          ensure_timer()
          render()
        else
          timer:stop()
          vim.api.nvim_echo({ { "LSP" } }, false, {
            id = message_id,
            kind = "progress",
            status = "success",
            title = frames[frame] .. " LSP",
            source = "lsp-progress",
          })
        end
      end,
    })

    vim.diagnostic.config({
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = " ",
          [vim.diagnostic.severity.HINT] = "",
        },
      },
      virtual_text = {
        prefix = "",
        spacing = 2,
        source = "if_many",
        format = function(diagnostic)
          return diagnostic.message
        end,
      },
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
