return {
  lazy = false,
  setup = false,
  after = function()
    vim.schedule(function()
      require("smart-splits").setup({
        mux = { backend = "smart-splits-backend-rex" },
      })
    end)
  end,
}
