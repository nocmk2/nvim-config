-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
-- Place this in your Neovim configuration (init.lua)
vim.keymap.set('n', '\\', ',', { noremap = true, silent = true })
