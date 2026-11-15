vim.o.cmdheight = 0

-- Enable new experimental UI2
require('vim._core.ui2').enable({
  enable = true,
  msg = {
    targets = {
      default = 'msg',
    },
  },
})

local ui2 = require('vim._core.ui2')
local messages = require('vim._core.ui2.messages')
local set_pos = messages.set_pos
messages.set_pos = function(target, focus)
  set_pos(target, focus)
  local win = ui2.wins.msg
  if (target == 'msg' or target == nil) and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_set_config(win, {
      relative = 'editor',
      anchor = 'NE',
      row = 1,
      col = vim.o.columns,
    })
  end
end

local function set_msg_highlights()
  local normal = vim.api.nvim_get_hl(0, { name = 'Normal' })
  vim.api.nvim_set_hl(0, 'MsgArea', { fg = normal.fg, bg = 'NONE' })
end
set_msg_highlights()
vim.api.nvim_create_autocmd('ColorScheme', { callback = set_msg_highlights })

vim.keymap.set('n', '<leader>n', '<cmd>messages<cr>', { desc = 'Notification history' })

-- Interface
vim.o.cursorline = true
vim.o.list = true
vim.o.listchars = 'tab:→ ,trail: ,nbsp:+,extends:›,precedes:‹'
vim.o.number = true
vim.o.numberwidth = 4
vim.o.relativenumber = true
vim.o.signcolumn = 'yes:1'
vim.o.ruler = false
vim.o.scrolloff = 6
vim.o.showbreak = '↪ '
vim.o.showmode = false
vim.o.sidescrolloff = 6
vim.o.smoothscroll = true
vim.o.title = true
vim.o.titlestring = 'nvim %t%( %M%) (%{fnamemodify(getcwd(), ":t")})'

if vim.env.SSH_TTY then
  vim.o.titlestring = 'SSH ' .. vim.o.titlestring
end

vim.o.winborder = 'rounded'
vim.opt.fillchars:append({ diff = ' ', eob = ' ', foldinner = ' ', msgsep = '‾' })
