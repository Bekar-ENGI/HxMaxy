-- user specific
-- Auto pairs

vim.keymap.set("i", "{", "{}<Left>")         
vim.keymap.set("i", "(", "()<Left>")
vim.keymap.set("i", "[", "[]<Left>")
vim.keymap.set("i", "\"", "\"\"<Left>")
vim.keymap.set("i", "'", "''<Left>")

-- leader key = space
vim.g.mapleader = " "

-- open netrw with space + e
vim.keymap.set("n","<leader>e",vim.cmd.Ex)

--clipboard
vim.opt.clipboard = "unnamedplus"

--copy and paste 
vim.keymap.set({"n","v"},"<leader>y",'"+y')
vim.keymap.set({"n","v"},"<leader>p",'"+p')

--native vim file format no fallback for lsp
vim.keymap.set("n", "<leader>f", function()
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd("normal! gg=G")
    vim.api.nvim_win_set_cursor(0, pos)
end, { noremap = true })

--lsp winborder
vim.opt.winborder = "rounded"

-- numbers
vim.opt.number = true;
vim.opt.relativenumber = true;

-- enable gui colors in term
vim.opt.termguicolors = true;

-- Indentation
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Tabs & spaces
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Backspace sanity
vim.opt.backspace = "indent,eol,start"

-- QOL
vim.opt.cursorline = true
vim.opt.scrolloff = 8

-- custom write, source, quit
vim.keymap.set("n", "<leader>o",":update<CR> :source<CR>") -- source out
vim.keymap.set("n","<leader>w",":write<CR>") -- write
vim.keymap.set("n","<leader>q", ":quit<CR>") -- quit

-- Search Optimization
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- theme
vim.cmd("syntax on");
--vim.cmd("colorscheme habamax")

-- move selections

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--exit visual mode cleanly
vim.keymap.set("v", "<Esc>", "<Esc>:noh<CR>", { desc = "Exit visual mode cleanly" })

-- netrw custom setting
vim.g.netrw_banner = 0 --disable banner
vim.g.netrw_liststyle = 3 -- tree view


-- execute commands in nvim 

vim.keymap.set('n', '<leader>t', ':!', { desc = 'Run shell command' })

-- require core, config and plugins
require("config.lazy")
require("config.mason")
require("plugins.rosepine")
require("plugins.cmp")
require("plugins.luasnip")
require("plugins.telescope")
require("plugins.netrw")
require("plugins.lualine")
require("core.buf")
require("core.autotag").setup()
