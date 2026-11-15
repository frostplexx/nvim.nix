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
