local map = vim.keymap.set

-- smart-splits
map("n", "<C-h>", function() require("smart-splits").move_cursor_left() end, { desc = "Move left" })
map("n", "<C-j>", function() require("smart-splits").move_cursor_down() end, { desc = "Move down" })
map("n", "<C-k>", function() require("smart-splits").move_cursor_up() end, { desc = "Move up" })
map("n", "<C-l>", function() require("smart-splits").move_cursor_right() end, { desc = "Move right" })
map("n", "<leader>mc", function()
  local ns = vim.api.nvim_create_namespace("nvim.multicursor")
  vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
  vim.cmd("normal! <C-l>")
end, { desc = "Clear multicursors" })
map("n", "<A-h>", function() require("smart-splits").resize_left() end, { desc = "Resize left" })
map("n", "<A-j>", function() require("smart-splits").resize_down() end, { desc = "Resize down" })
map("n", "<A-k>", function() require("smart-splits").resize_up() end, { desc = "Resize up" })
map("n", "<A-l>", function() require("smart-splits").resize_right() end, { desc = "Resize right" })

-- terminal split navigation
map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Terminal left" })
map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Terminal down" })
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Terminal up" })
map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Terminal right" })

map("n", "U", "<C-r>", { desc = "Redo" })
map("n", "yc", "yygccp", { desc = "Duplicate line and comment first", remap = true })
map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight", silent = true })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })

map("n", "]t", "<cmd>tabnext<cr>", { desc = "Next tab" })
map("n", "[t", "<cmd>tabprevious<cr>", { desc = "Previous tab" })
map("n", "<leader>tn", "<cmd>tabnew<cr>", { desc = "New tab" })
map("n", "<leader>tx", "<cmd>tabclose<cr>", { desc = "Close tab" })
map("n", "<leader>to", "<cmd>tabonly<cr>", { desc = "Close other tabs" })
for i = 1, 9 do
  map("n", "<A-" .. i .. ">", "<cmd>tabnext " .. i .. "<cr>", { desc = "Go to tab " .. i })
end

map("v", "<leader>s", 'y:%s/<C-r>"//gc<Left><Left><Left>', { desc = "Search and replace selected text" })

map("n", "<leader>db", function()
  require("mini.bufremove").delete(0, false)
end, { desc = "Delete buffer" })

map("n", "<leader>u", function()
  vim.cmd("packadd nvim.undotree")
  require("undotree").toggle()
end, { desc = "Toggle undotree" })


map('n', '<C-n>', 'Qn')
