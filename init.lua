vim.o.number = true
vim.o.relativenumber = true
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.termguicolors = true
vim.opt.mouse = ""
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.splitbelow = false
vim.o.splitright = false
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

vim.keymap.set('n', '<C-t>', ':tabnew<CR>:terminal<CR>')
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('n', '<leader>b', ':ls<CR>')
vim.keymap.set('n', '<C-->', '<C-w>-')
vim.keymap.set('n', '<C-+>', '<C-w>+')

vim.keymap.set('n', '<leader>d', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local attached = false
    for _, client in pairs(vim.lsp.get_active_clients()) do
        if client.attached_buffers[bufnr] then
            attached = true
            break
        end
    end
    if attached then
        vim.lsp.buf.hover()
    else
        vim.notify("No LSP attached to this buffer", vim.log.levels.WARN)
    end
end, { noremap = true, silent = true })

for i = 1, 30 do
    vim.keymap.set('n', '<leader>' .. i .. 'b', ':b ' .. i .. '<CR>')
end

local function closeAllOtherTabs()
    vim.cmd('tabonly')
end

for i = 1, 30 do
    vim.keymap.set('n', '<leader>' .. i .. 't', ':tabnext ' .. i .. '<CR>')
end
vim.keymap.set('n', '<leader>t', ':tabs<CR>')
vim.keymap.set('n', '<Tab>', ':tabnext<CR>')
vim.keymap.set('n', '<S-Tab>', ':tabprevious<CR>')
vim.keymap.set('n', '<leader>q', ':tabclose<CR>')
vim.keymap.set('n', '<leader>n', ':tabnew<CR>')
vim.keymap.set('n', '<leader>Q', closeAllOtherTabs)
vim.keymap.set('n', '<leader>f', ':tabnew<CR>:e ')
-- doesn't work how I'd want it to --> ''vim.keymap.set('n', ':help ', ':tabnew<CR>:help<CR><C-w>w<C-w>25-<C-w>w:/')
vim.keymap.set('i', '(', '()<Esc>ha')
vim.keymap.set('i', '{', '{}<Esc>ha')
vim.keymap.set('i', '[', '[]<Esc>ha')
vim.keymap.set('i', "'", "''<Esc>ha")
vim.keymap.set('i', '"', '""<Esc>ha')
vim.keymap.set('i', '`', '``<Esc>ha')

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

local function safeCall(callThis, ...)
    local function errorHandler(error)
        return debug.traceback(error, 2)
    end
    local success, error = xpcall(function(...)
        return callThis(...)
    end, errorHandler, ...)
    if not success then
        vim.notify(error, vim.log.levels.ERROR)
    end
end

local dataPath = vim.fn.stdpath('data') .. '/site/pack/'

local plugins = {
    plugins = {
        {
            org = 'EdenEast',
            name = 'nightfox',
            gitName = 'nightfox.nvim',
            optional = false,
            helpDocs = true,
            setup = false,
            setupParams = {}
        },
        {
            org = 'vague-theme',
            name = 'vague',
            gitName = 'vague.nvim',
            optional = false,
            helpDocs = false,
            setup = true,
            setupParams = {}
    	},
        {
            org = 'rebelot',
            name = 'kanagawa',
            gitName = 'kanagawa.nvim',
            optional = false,
            helpDocs = false,
            setup = true,
            setupParams = {
                compile = false,             -- enable compiling the colorscheme
                undercurl = true,            -- enable undercurls
                commentStyle = { italic = true },
                functionStyle = {},
                keywordStyle = { italic = true},
                statementStyle = { bold = true },
                typeStyle = {},
                transparent = false,         -- do not set background color
                dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
                terminalColors = true,       -- define vim.g.terminal_color_{0,17}
                colors = {                   -- add/modify theme and palette colors
                    palette = {},
                    theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
                },
                overrides = function(colors) -- add/modify highlights
                    return {}
                end,
                theme = "wave",              -- Load "wave" theme
                background = {               -- map the value of 'background' option to a theme
                    dark = "wave",           -- try "dragon" !
                    light = "lotus"
                },
            },
        }
    },
    repo = function(plugin)
            return 'https://github.com/' .. plugin.org .. '/' .. plugin.gitName .. '.git'
        end,
    path = function(plugin)
        if plugin.optional == true then
            return dataPath .. plugin.org .. '/opt/' .. plugin.gitName
        else
            return dataPath .. plugin.org .. '/start/' .. plugin.gitName
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
        safeCall(vim.cmd, 'packadd! ' .. plugin.name)
    end
    if plugin.helpDocs == true then
        print("getting freshly installed plugin's helptags'")
        safeCall(vim.cmd, 'helptags ' .. plugins.path(plugin) .. '/doc')
    else
        print('no help docs or tags for this one')
    end
end

local function checkAllPlugins(plugins)
    for i, plugin in ipairs(plugins.plugins) do
        if checkForPlugin(plugin) == false then
            getPlugin(plugin)
        else
            if plugin.helpDocs == true then
                print("getting allready installed plugin's helptags")
                safeCall(vim.cmd, 'helptags ' .. plugins.path(plugin) .. '/doc')
            else
                print('no help docs or tags for this one')
            end
        end
        if plugin.setup then
            print('setup...')
            safeCall(require(plugin.name).setup, plugin.setupParams)
        else
            print('NOT doing setup')
        end
    end
end


safeCall(checkAllPlugins, plugins)
-- safeCall(require('vague').setup, {})
-- safeCall(require('kanagawa').setup, {})
safeCall(vim.cmd, 'colorscheme kanagawa')

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function()
        vim.lsp.start({
            name = "lua_ls",
            cmd = { "lua-language-server" },
            root_dir = vim.fs.dirname(vim.fs.find({".git", ".luarc.json", ".luarc.jsonc"}, { upward = true })[1]),
            settings = {
                Lua = {
                    codeLens = { enable = true },
                    hint = { enable = true, semicolon = "Disable" },
                },
            },
        })
    end,
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'python',
    callback = function()
        vim.lsp.start({
            name = 'pylsp',
            cmd = {'pylsp'},
            root_dir = vim.fs.dirname(vim.fs.find({".git", "pyproject.toml"}, { upward = true })[1]),
            settings = {
                pylsp = {
                    configurationSources = {'pycodestyle'},
                    plugins = {
                        jedi_completion = {
                            enabled = true,
                            fuzzy = true,
                            include_params = true
                        },
                        jedi = {
                            extra_paths = {
                                '/home/alex/repos/picar-x',
                                '/home/alex/repos/robot_hat'
                            }
                        },
                        jedi_definition = {
                            enabled = true,
                            follow_imports = true
                        },
                        jedi_hover = {
                            enabled = true,
                        },
                        jedi_symbols = {
                            enabled = true
                        },
                        jedi_references = {
                            enabled = true
                        },
                        pycodestyle = {
                            enabled = true,
                            indent = 4
                        },
                        pyflakes = {
                            enabled = true
                        }
                    }
                },
            }
    	})
        print("tried to start 'pylsp'")
    end,
})


 
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
