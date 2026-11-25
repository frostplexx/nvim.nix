return {
  lazy = false,
  priority = 100,
  setup = false,
  after = function()
    -- Rex no longer injects REX_SESSION, but the backend requires it.
    -- The CLI accepts a block ID wherever it accepts a session ID.
    if (vim.env.REX_SESSION or "") == "" and (vim.env.REX_BLOCK or "") ~= "" then
      vim.env.REX_SESSION = vim.env.REX_BLOCK
    end
    require("smart-splits-backend-rex").setup {}
  end,
}
