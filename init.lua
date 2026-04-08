local function tableLength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

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

-- vim.api.nvim_create_autocmd('TextYankPost', {
--   desc = 'Highlight when yanking (copying) text',
--   group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
--   callback = function() vim.hl.on_yank() end,
-- })

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
vim.keymap.set('n', '<leader>q', function()
    local buffNumberList = vim.fn.tabpagebuflist()
    for _, buffNumber in ipairs(buffNumberList) do
        vim.cmd('bd' .. buffNumber)
    end
end)
vim.keymap.set('n', '<leader>n', ':tabnew<CR>')
vim.keymap.set('n', '<leader>Q', function()
    local tabNumberList = vim.api.nvim_list_tabpages()
    local tabs = tableLength(tabNumberList)
    local tab = 1
    local function closeTabBuffers()
        local currentTabNumber = vim.api.nvim_get_current_tabpage()
        if tab == currentTabNumber then
            tab = tab + 1
        elseif tab ~= currentTabNumber then
            local buffNumberList = vim.fn.tabpagebuflist(tab)
            for _, buffNumber in ipairs(buffNumberList) do
                vim.cmd('bd' .. buffNumber)
            end
            tab = 1
            tabs = tabs - 1
        end
    end
    while tabs > 1 do
        closeTabBuffers()
    end
end)
vim.keymap.set('n', '<leader>f', ':tabnew<CR>:e ')
vim.keymap.set('c','help ', '<Esc>:tab help ')
vim.keymap.set({'i', 'c', 't'}, '<M-h>', '<Esc>h')
vim.keymap.set({'i', 'c', 't'}, '<M-j>', '<Esc>j')
vim.keymap.set({'i', 'c', 't'}, '<M-k>', '<Esc>k')
vim.keymap.set({'i', 'c', 't'}, '<M-l>', '<Esc>l')

local function fastDownScroll()
    local winId = vim.api.nvim_get_current_win()
    local winInfo = vim.fn.getwininfo(winId)[1]
    local top = winInfo.topline
    local bot = winInfo.botline
    local pos = vim.api.nvim_win_get_cursor(winId)[1]
    local winHeight = bot - top
    local view = vim.fn.winsaveview()
    local topLine = view.topline
    view.topline = topLine + winHeight - 4
    local cursor = view.lnum
    view.lnum = cursor + winHeight - 4
    vim.fn.winrestview(view)
end

local function fastUpScroll()
    local winId = vim.api.nvim_get_current_win()
    local winInfo = vim.fn.getwininfo(winId)[1]
    local top = winInfo.topline
    local bot = winInfo.botline
    local winHeight = bot - top
    local view = vim.fn.winsaveview()
    local topLine = view.topline
    view.topline = topLine - winHeight + 4
    local cursor = view.lnum
    view.lnum = cursor - winHeight + 4
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

local dataPath = vim.fn.stdpath('data')

local pluginsPath = dataPath .. '/site/pack/'

print("- dataPath: " .. dataPath)

local plugins = {
    plugins = {
        {
            org = 'neovim',
            name = 'nvim-lspconfig',
            gitName = 'nvim-lspconfig',
            optional = false,
            helpDocs = true,
            setup = false,
            setupParams = {}
        },
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
            return pluginsPath .. plugin.org .. '/opt/' .. plugin.gitName
        else
            return pluginsPath .. plugin.org .. '/start/' .. plugin.gitName
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

local pathToLspConfigs = dataPath .. '/site/pack/neovim/start/nvim-lspconfig/lsp/'

local LSPsInUse = {
    {
        fileTypeName = 'lua',
        fileExtension = '.lua',
        configFileName = 'lua_ls.lua'
    },
    {
        fileTypeName = 'php',
        fileExtension = '.php',
        configFileName = 'phpactor.lua'
    },
    {
        fileTypeName = 'javascript',
        fileExtension = '.js',
        configFileName = 'ts_ls.lua'
    },
    {
        fileTypeName = 'typescript',
        fileExtension = '.ts',
        configFileName = 'ts_ls.lua'
    },
    {
        fileTypeName = 'C#',
        fileExtension = '.cs',
        configFileName = 'omnisharp.lua'
    },
    {
        fileTypeName = 'python',
        fileExtension = '.py',
        configFileName = 'pyright.lua'
    },
}

local function setupLspClientAttachOnFileOpen()
    vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function(event)
--             print('- event: \n' .. vim.inspect(event))
--             local filePath = event.file
--             print('- file path: \n' .. filePath)
--             local reversedFilePath = string.reverse(filePath)
--             print('- reversed file path: \n' .. reversedFilePath)
--             local extensionIndexFromEnd = string.find(reversedFilePath, '.', 1, true)
--             print('- extension from end index: \n' .. extensionIndexFromEnd)
--             local fileExtension = string.sub(filePath, -extensionIndexFromEnd)
--             local fileExtension = string.sub(event.file, - string.find(string.reverse(event.file), '.', 1, true)) 
--             print('- file extension: \n' .. fileExtension)
            for _, details in ipairs(LSPsInUse) do
                if  string.sub(event.file, - string.find(string.reverse(event.file), '.', 1, true)) == details.fileExtension then
                    print("- matched '" .. details.fileTypeName .. "' file type")
                    vim.lsp.start(dofile(pathToLspConfigs .. details.configFileName))
                end
            end
        end
    })
end

safeCall(checkAllPlugins, plugins)
safeCall(vim.cmd, 'colorscheme kanagawa')

safeCall(setupLspClientAttachOnFileOpen)



