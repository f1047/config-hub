-- clipboard sharing
vim.api.nvim_command('set clipboard&')
vim.api.nvim_command('set clipboard^=unnamedplus')

-- indent
vim.api.nvim_command('set autoindent')
vim.api.nvim_command('set tabstop=3')
vim.api.nvim_command('set softtabstop=3')
vim.api.nvim_command('set shiftwidth=3')
vim.api.nvim_command('set expandtab')
