local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = false

-- Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.signcolumn = "yes"
opt.scrolloff = 8
opt.cursorline = true

-- Behavior
opt.wrap = false
opt.swapfile = false
opt.backup = false
opt.undodir = vim.fn.stdpath("state") .. "/undo"
opt.undofile = true
opt.updatetime = 50
opt.clipboard = "unnamedplus"
opt.splitright = true
opt.splitbelow = true

-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "
