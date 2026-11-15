return {
  lazy = false,
  setup = false,
  after = function()
    require("smart-splits").setup({
      mux = { backend = "smart-splits-backend-rex" },
    })
  end,
}
