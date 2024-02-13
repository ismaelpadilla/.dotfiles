vim.opt.mouse="a"
vim.opt.guicursor=""
vim.opt.statusline="%F"
vim.opt.cursorline=true
vim.opt.scrolloff=8
vim.opt.showmatch=true
vim.opt.incsearch=true
vim.opt.hlsearch=true
vim.opt.termguicolors=true

-- line numbers
vim.opt.number=true
vim.opt.relativenumber=true

vim.opt.shiftwidth = 4
vim.opt.tabstop=4
vim.opt.expandtab=true

vim.opt.foldmethod="indent"
vim.opt.foldlevelstart=99

vim.opt.path = vim.opt.path + "**"
vim.opt.wildignore = vim.opt.wildignore + "**/node_modules/**"

vim.opt.splitright=true


vim.g.netrw_liststyle=3
vim.g.netrw_winsize=25

-- eol char
-- vim.opt.list = true
-- vim.opt.listchars:append("eol:↴")
