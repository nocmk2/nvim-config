return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        rust_analyzer = {
          mason = false,
          cmd = { vim.fn.expand("~/.cargo/bin/rust-analyzer") },
        },
      },
    },
  },
}
