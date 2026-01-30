vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.opt.mouse = ""
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.schedule(
    function()
        vim.o.clipboard = "unnamedplus"
    end
)
vim.o.mouse = ""
vim.o.confirm = true
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set({"n", "v"}, "<leader>h", "0")
vim.keymap.set({"n", "v"}, "<leader>l", "$")
vim.keymap.set("n", "c<leader>l", "c$")
vim.keymap.set("n", "c<leader>h", "c0")
vim.keymap.set("n", "d<leader>l", "d$")
vim.keymap.set("n", "d<leader>h", "d0")
vim.keymap.set({"n", "i", "v"}, "<C-s>", "<Esc>:w<CR>")
vim.keymap.set({"n", "i", "v"}, "<C-q>", "<Esc>:wq<CR>")
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('n', '<leader>m', ':messages<CR>')

vim.keymap.set('n', '<C-t>', ':terminal<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<C-t>', ':terminal<CR>')
vim.keymap.set('n', '<leader>b', ':ls<CR>')
vim.keymap.set('n', '<leader>1', ':b 1<CR>')
vim.keymap.set('n', '<C-->', '<C-w>-')
vim.keymap.set('n', '<C-+>', '<C-w>+')
for i = 1, 9 do
    vim.keymap.set('n', '<leader>' .. i, ':b ' .. i .. '<CR>')
end
-- vim.keymap.set('i', '(', '()<Esc>ha')
-- vim.keymap.set('i', '{', '{}<Esc>ha')
-- vim.keymap.set('i', '[', '[]<Esc>ha')
-- vim.keymap.set('i', "'", "''<Esc>ha")
-- vim.keymap.set('i', '"', '""<Esc>ha')
-- vim.keymap.set('i', '`', '``<Esc>ha')

local function fastDownScroll()
    local winId = vim.api.nvim_get_current_win()
    local winInfo = vim.fn.getwininfo(winId)[1]
--    print(vim.inspect(vim.fn.getwininfo(winId)[1]))
    local top = winInfo.topline
    local bot = winInfo.botline
    local pos = vim.api.nvim_win_get_cursor(winId)[1]
    local winHeight = bot - top
    local view = vim.fn.winsaveview()
--    print(vim.inspect(view))
    local topLine = view.topline
    view.topline = topLine + winHeight - 4
    local cursor = view.lnum
    view.lnum = cursor + winHeight - 4
--    print(vim.inspect(view))
    vim.fn.winrestview(view)
end

local function fastUpScroll()
    local winId = vim.api.nvim_get_current_win()
    local winInfo = vim.fn.getwininfo(winId)[1]
--    print(vim.inspect(vim.fn.getwininfo(winId)[1]))
    local top = winInfo.topline
    local bot = winInfo.botline
    local winHeight = bot - top
    local view = vim.fn.winsaveview()
--    print(vim.inspect(view))
    local topLine = view.topline
    view.topline = topLine - winHeight + 4
    local cursor = view.lnum
    view.lnum = cursor - winHeight + 4
--    print(vim.inspect(view))
    vim.fn.winrestview(view)
end

vim.keymap.set({"n", "v"}, "<M-j>", fastDownScroll)
vim.keymap.set({"n", "v"}, "<M-k>", fastUpScroll)

local function checkForPlugin(plugin)
    if not vim.uv.fs_stat(plugins.path(plugin)) then
        return talse
    else
        return true
	end
end

local dataPath = vim.fn.stdpath('data') .. '/site/pack/'

local function getPlugin(plugin)
   vim.cmd(':!git clone https://github.com/' .. plugins.repo(plugin) .. ' ' .. plugins.path(plugin) .. '<CR>')
    if plugin.optional == true then
        vim.cmd(':packadd! ' .. plugin.name .. '<CR>')
    end
    vim.cmd(':helptags ' .. path .. '/doc')
end

local plugins = {
    plugins = {
        {
            name = 'nightfox',
            org = 'EdenEast',
            optional = false,
        }
    },
    repo = function(plugin)
            return plugin.org .. '/' .. plugin.name .. '.nvim.git'
        end,
    path = function(plugin)
        if plugin.optional == true then
            return dataPath .. plugin.org .. '/opt/' .. plugin.name .. '.nvim'
        else
            return dataPath .. plugin.org .. '/start/' .. plugin.name .. '.nvim'
        end
    end
}

local function checkAllPlugins(plugins)
    for i, plugin in ipairs(plugins.plugins) do
        if checkForPlugin(plugins.plugins[i]) == false then
            getPlugin(plugins.plugins[i])
        end
    end
end

checkAllPlugins(plugins)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
    },
    install = { colorscheme = { "habamax", "nightfox" } },
    checker = { enabled = true },
})

vim.cmd(':colorscheme nightfox')
-- vim.cmd('colorscheme habamax')

