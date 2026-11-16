return {
  -- Loaded before FileType, so the autocmd below is registered in time for the
  -- first buffer, but not for a start screen with no file.
  event = { "BufReadPre", "BufNewFile" },
  setup = false,
  after = function()
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
