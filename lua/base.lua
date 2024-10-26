-- https://vimdoc.sourceforge.net/htmldoc/options.html
-- https://neovim.io/doc/user/quickref.html#option-list
local opt = vim.o
opt.encoding = 'utf-8'
opt.number = true
opt.clipboard = "unnamedplus"
opt.list = true
opt.expandtab = true
opt.tabstop = 2
opt.shiftwidth = 2
opt.autoindent = true
opt.smartindent = true
opt.wrap = false
opt.termguicolors = true
opt.wildmenu = true
opt.ruler = true
opt.smartcase = true
opt.showmatch = true

local g = vim.g
g.mapleader = ' '
g.maplocalleader = "\\"

