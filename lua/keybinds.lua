local vim = vim
local nmap = function(keybind, func, desc)
	vim.api.nvim_set_keymap('n', keybind, func, { desc = desc })
end

local nmap_opt = function(keybind, func, opt)
	vim.api.nvim_set_keymap('n', keybind, func, opt)
end
local vmap_opt = function(keybind, func, opt)
	vim.api.nvim_set_keymap('v', keybind, func, opt)
end

local options = { noremap = true, silent = true }

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic message" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic message" })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set('n', '<leader>t', vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


--' Quick save
nmap('<leader>w', ':w<CR>', 'Quick save')
--' Quick save and quit
nmap('<leader>wq', ':wq<CR>', 'Quick save and quit')
-- Quick quit
nmap('<leader>q', ':q<CR>', 'Quick quit')
-- Multi cursor selection
nmap('<C-k>', '<C-Up>', 'Multi cursor up')
nmap('<C-j>', '<C-Down>', 'Multi cursor down')
-- Move to
nmap('<leader>h', '<C-w>h', 'Move to left pane')
nmap('<leader>j', '<C-w>j', 'Move to lower pane')
nmap('<leader>k', '<C-w>k', 'Move to upper pane')
nmap('<leader>l', '<C-w>l', 'Move to right pane')
-- Git shortcuts
nmap('<leader>gs', ':Git status<CR>', 'Run [G]it [S]tatus')
nmap('<leader>gp', ':Git pull<CR>', 'Run [G]it [P]ull')
-- Remove search highlight
nmap_opt('<Esc>', ':noh<CR>', { desc = 'Remove search highlight', silent = true })

nmap('<leader><F5>', ':UndotreeToggle<CR>', 'Open Undotree')

-- Format, this is a separate keybind since not all file types have a formatter
-- enabled
nmap('<leader>f', ':Format<CR>', 'Run [f]ormater')

-- quick fix next and previous
nmap('<leader>]', ':cnext<CR>', 'Next line from quickfix list')
nmap('<leader>[', ':cprev<CR>', 'Previous line from quickfix list')

-- Disable arrow keys
nmap_opt('<Up>', '<Nop>', { noremap = true })
nmap_opt('<Down>', '<Nop>', { noremap = true })
nmap_opt('<Left>', '<Nop>', { noremap = true })
nmap_opt('<Right>', '<Nop>', { noremap = true })
-- Open Neotree
-- nmap_opt('<F1>', ':Neotree toggle<cr>', { noremap = true, desc = 'Toggle Neotree' })

-- Tab keybinds
-- Move to previous/next tab
nmap_opt('<A-,>', '<Cmd>BufferPrevious<CR>', options)
nmap_opt('<A-.>', '<Cmd>BufferNext<CR>', options)

nmap_opt('<A-<>', '<Cmd>BufferPrevious<CR>', options)
nmap_opt('<A->>', '<Cmd>BufferNext<CR>', options)
nmap_opt('¯', '<Cmd>BufferPrevious<CR>', options)
nmap_opt('˘', '<Cmd>BufferNext<CR>', options)

-- Re-order to previous/next
nmap_opt('<A-<>', '<Cmd>BufferMovePrevious<CR>', options)
nmap_opt('<A->>', '<Cmd>BufferMoveNext<CR>', options)

-- Close tab
nmap_opt('<A-c>', '<Cmd>BufferClose<CR>', options)
nmap_opt('ç', '<Cmd>BufferClose<CR>', options)

nmap_opt('<C-S-K>', ':m -2<CR>', { noremap = true, silent = true })
nmap_opt('<C-S-J>', ':m +1<CR>', { noremap = true, silent = true })
vmap_opt('<C-S-K>', ":m '<-2<CR>gv", { noremap = true, silent = true })
vmap_opt('<C-S-J>', ":m '>+1<CR>gv", { noremap = true, silent = true })
