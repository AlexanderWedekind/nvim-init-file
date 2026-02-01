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

local dataPath = vim.fn.stdpath('data') .. '/site/pack/'

local plugins = {
    plugins = {
        {
            name = 'nightfox',
            org = 'EdenEast',
            optional = false,
        }
    },
    repo = function(plugin)
            return 'https://github.com/' .. plugin.org .. '/' .. plugin.name .. '.nvim.git'
        end,
    path = function(plugin)
        if plugin.optional == true then
            return dataPath .. plugin.org .. '/opt/' .. plugin.name .. '.nvim'
        else
            return dataPath .. plugin.org .. '/start/' .. plugin.name .. '.nvim'
        end
    end
}

local function checkForPlugin(plugin)
    print('- checking for ' .. plugin.name .. '...')
    if not vim.loop.fs_stat(plugins.path(plugin)) then
        print('...not found')
        return false
    else
        print('is installed')
        return true
	end
end

local function getPlugin(plugin)
    print('getting ' .. plugin.name)
    print('cloning ' .. plugins.repo(plugin))
    local output = vim.fn.system({'git', 'clone', plugins.repo(plugin), plugins.path(plugin)})
    print('output: ' .. output)
    if plugin.optional == true then
        vim.cmd('packadd! ', plugin.name)
    end
    print("doing 'freshly installed helptags'")
    vim.cmd('helptags ' .. plugins.path(plugin) .. '/doc')
end

local function checkAllPlugins(plugins)
    for i, plugin in ipairs(plugins.plugins) do
        if checkForPlugin(plugins.plugins[i]) == false then
            getPlugin(plugins.plugins[i])
        else
            print("doing 'allready installed helptags'")
            vim.cmd('helptags ' .. plugins.path(plugin) .. '/doc')
        end
    end
end

checkAllPlugins(plugins)

vim.schedule(function()
    vim.cmd('colorscheme nightfox')
end)

-- blue           
-- ~            carbonfox      
-- ~            darkblue       
-- ~            dawnfox        
-- ~            dayfox         
-- ~            default        
-- ~            delek          
-- ~            desert         
-- ~            duskfox        
-- ~ ok-ish     elflord       deep black, yellow line nr, neon text, perfect closing bracket cursor 
-- ~            evening        
-- ~ good + broken     habamax       very dark pleasant grey, clear grey line nr, nice orange current line, subtle/non intrusive but clear to see current line highlight, gentle but good coloured text, terrible closing bracket cursor completely confusing and makes whole scheme unuseable 
-- ~    bad     industry       
-- ~ 1 feature  koehler        like default but with deep black bg, annoying to look at, PERFECT closing bracket cursor
-- ~            lunaperche     
-- ~            morning        
-- ~            murphy         
-- ~            nightfox       
-- ~            nordfox        
-- ~  meh/ok    pablo          
-- ~            peachpuff      
-- ~  ok-ish    quiet         deep black, monochrome, all good, perfect closing bracket cursor, white text and grey comments, literally NO other colour highlight - not even strings 
-- ~            ron            
-- ~            shine          
-- ~            slate          
-- ~            terafox        
-- ~            torte          
-- init.lua     zellner     
