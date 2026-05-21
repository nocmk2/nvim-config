return {
  {
    "tpope/vim-fugitive",
    dependencies = { "shumphrey/fugitive-gitlab.vim" },
    config = function()
      -- 通过环境变量注入 internal GitLab domain，避免公开 repo 泄露内部地址
      vim.g.fugitive_gitlab_domains = { os.getenv("GITLAB_DOMAIN") or "https://git.example.com" }
    end,
  },
}
