-- move window
vim.api.nvim_set_keymap('n', '<Leader>j', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>k', '<C-w>k', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>l', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>h', '<C-w>h', { noremap = true, silent = true })

-- split window
vim.api.nvim_set_keymap('n', '<Leader>s', ':<C-u>sp\n', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>v', ':<C-u>vs\n', { noremap = true })

-- close window
vim.api.nvim_set_keymap('n', '<Leader>w', ':<C-u>w\n', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>q', ':<C-u>q\n', { noremap = true })
vim.api.nvim_set_keymap('n', '<Leader>wq', ':<C-u>wq\n', { noremap = true })

vim.api.nvim_set_keymap('i', '<C-k>', '<Up>', {})
vim.api.nvim_set_keymap('i', '<C-j>', '<Down>', {})
vim.api.nvim_set_keymap('i', '<C-h>', '<Left>', {})
vim.api.nvim_set_keymap('i', '<C-l>', '<Right>', {})

