vim.o.clipboard = 'unnamedplus'
vim.o.fileencoding = 'utf-8'
vim.opt.shortmess:append('I')
vim.g.editorconfig = true
vim.g.loaded_netrwPlugin = 1

-- Indentation
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.tabstop = 4
vim.o.smartindent = true

-- Search
vim.o.ignorecase = true
vim.o.inccommand = 'split'
vim.o.smartcase = true

-- Windows
vim.o.splitbelow = true
vim.o.splitkeep = 'screen'
vim.o.splitright = true

-- Text layout and folding
vim.o.breakindent = true
vim.o.foldlevelstart = 99
vim.o.foldtext = ''
vim.o.formatexpr = '1' -- gq uses the built-in formatter instead of the language server
vim.o.linebreak = true
vim.o.wrap = false

-- Behavior
vim.o.backup = false
vim.o.confirm = true
vim.o.exrc = true
vim.o.swapfile = false
vim.o.textwidth = 120
vim.o.jumpoptions = 'clean,view'
vim.o.spelllang = 'en_us'
vim.o.startofline = true
vim.o.synmaxcol = 200
vim.o.timeoutlen = 3000
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatecount = 0
vim.o.updatetime = 300
vim.o.virtualedit = 'block'
vim.opt.diffopt:append({ 'algorithm:histogram', 'hiddenoff' })
vim.opt.sessionoptions:remove({ 'blank', 'help', 'terminal' })
vim.opt.shada:append({ 'rgitsigns:', 'rhealth:', 'rman:', 'rfile:///var/folders/' })

