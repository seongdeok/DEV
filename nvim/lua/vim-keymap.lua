vim.g.mapleader = " "

local keymap = vim.keymap
keymap.set('n', '<leader>h', '<C-w>h', {})
keymap.set('n', '<leader>l', '<C-w>l', {})
keymap.set('n', '<leader>j', '<C-w>j', {})
keymap.set('n', '<leader>k', '<C-w>k', {})

keymap.set('n', '<leader>q', '<C-w>q', {})
keymap.set('n', '<leader>v', ':vs<CR>', {})
keymap.set('n', '<leader>s', ':sp<CR>', {})
keymap.set("i", "jk", "<ESC>", {})

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
