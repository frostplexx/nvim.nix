return {
  lazy = false,
  priority = 100,
  setup = false,
  after = function()
    require("smart-splits-backend-rex").setup {}
  end,
}
