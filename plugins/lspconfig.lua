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
    "nixfmt",
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
    vim.lsp.config("rust_analyzer", {
      root_dir = function(bufnr, on_dir)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        local root = vim.fs.root(fname, { "Cargo.toml", "rust-project.json" })
        on_dir(root or vim.fs.dirname(fname))
      end,
    })

    local flake = "(builtins.getFlake (toString ./.))"
    local function firstConfigurationOptions(attribute)
      return "let f = "
        .. flake
        .. "; s = f."
        .. attribute
        .. " or null; in if s == null || builtins.attrNames s == [ ] then { } else builtins.head (builtins.map (name: s.${name}.options) (builtins.attrNames s))"
    end

    vim.lsp.config("nixd", {
      settings = {
        nixd = {
          nixpkgs = {
            expr = "import " .. flake .. ".inputs.nixpkgs { }",
          },
          formatting = {
            command = { "nixfmt" },
          },
          options = {
            nixos = { expr = firstConfigurationOptions("nixosConfigurations") },
            home_manager = { expr = firstConfigurationOptions("homeConfigurations") },
          },
        },
      },
    })

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
          pcall(function()
            require("vim._core.ui2.messages").msg:clear()
          end)
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
    map("n", "<leader>ls", function()
      require("mini.extra").pickers.lsp({ scope = "document_symbol" })
    end, { desc = "Document symbols" })
    map("n", "<leader>lS", function()
      require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
    end, { desc = "Workspace symbols" })
    map("n", "<leader>li", function()
      require("mini.extra").pickers.lsp({ scope = "implementation" })
    end, { desc = "Implementations" })
    map("n", "<leader>lr", function()
      require("mini.extra").pickers.lsp({ scope = "references" })
    end, { desc = "References" })
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
