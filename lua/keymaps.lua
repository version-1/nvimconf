local map = vim.api.nvim_set_keymap
-- move window
map('n', '<Leader>j', '<C-w>j', { noremap = true, silent = true })
map('n', '<Leader>k', '<C-w>k', { noremap = true, silent = true })
map('n', '<Leader>l', '<C-w>l', { noremap = true, silent = true })
map('n', '<Leader>h', '<C-w>h', { noremap = true, silent = true })

-- split window
map('n', '<Leader>s', ':<C-u>sp\n', { noremap = true })
map('n', '<Leader>v', ':<C-u>vs\n', { noremap = true })

-- close window
map('n', '<Leader>w', ':<C-u>w\n', { noremap = true })
map('n', '<Leader>q', ':<C-u>q\n', { noremap = true })
map('n', '<Leader>wq', ':<C-u>wq\n', { noremap = true })

-- open terminal
map('n', '<Leader>tt', ':terminal\n', { noremap = true })

map('i', '<C-k>', '<Up>', {})
map('i', '<C-j>', '<Down>', {})
map('i', '<C-h>', '<Left>', {})
map('i', '<C-l>', '<Right>', {})

-- show diagnostics
map('n', '<Leader>d', ':lua vim.diagnostic.open_float()<CR>', { noremap = true })

-- rebind embeded command
map('n', '<C-_>', 'gcc', { noremap = false })
map('v', '<C-_>', 'gc', { noremap = false })
