vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.termguicolors = true

vim.g.mapleader = " "

vim.keymap.set("n", "<leader>1", "0")
vim.keymap.set("n", "<leader>2", "$")
vim.keymap.set("n", "d<leader>2", "d$")
vim.keymap.set("n", "d<leader>1", "d0")
vim.keymap.set({"n", "i", "v"}, "<C-s>", "<Esc>:w<CR>")
vim.keymap.set({"n", "i", "v"}, "<C-q>", "<Esc>:wq<CR>")
