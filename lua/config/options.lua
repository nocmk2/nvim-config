-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
-- vim.g.mapleader = ","autoformat = true,
--
--
vim.g.mapleader = ","
vim.g.autoformat = false
-- vim.opt.list = true
vim.opt.listchars = {
  tab = "> ",
  trail = " ",
  nbsp = "+",
}
vim.opt.cursorline = false

if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
  vim.opt.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  vim.opt.foldmethod = "expr"
  vim.opt.foldtext = ""
else
  vim.opt.foldmethod = "indent"
  vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end

-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "pyright"
-- Set to "ruff_lsp" to use the old LSP implementation version.
vim.g.lazyvim_python_ruff = "ruff"

-- for avante.lua
-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
