vim.g.mapleader = " "
vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set nu")
vim.keymap.set('n', '<leader>h', '<C-w>h', {})
vim.keymap.set('n', '<leader>l', '<C-w>l', {})
vim.keymap.set('n', '<leader>q', '<C-w>q', {})
vim.keymap.set('n', '<leader>v', ':vs<CR>', {})
vim.keymap.set('n', '<leader>s', ':sp<CR>', {})

