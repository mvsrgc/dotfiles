local o = vim.o
local opt = vim.opt

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

opt.swapfile = false

-- General settings
o.relativenumber = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.smartindent = true
o.signcolumn = "yes"
o.hlsearch = false
o.cursorline = true
o.breakindent = true
o.mouse = "a"
o.clipboard = "unnamedplus"
o.undofile = true
o.ignorecase = true
o.termguicolors = true
o.pumheight = 10
o.updatetime = 250
o.timeoutlen = 300
o.splitright = true
o.showmode = false
o.guifont = "RobotoMono Nerd Font:h13"
