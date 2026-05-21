return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,
    opts = {
      provider = "openai",
      auto_suggestions_provider = "openai",
      providers = {
        openai = {
          model = "deepseek/deepseek-v4-flash",
          -- 通过环境变量注入 internal endpoint，避免公开 repo 泄露内部地址
          endpoint = os.getenv("LLM_ENDPOINT") or os.getenv("OPENAI_BASE_URL") or "http://localhost:11434/v1",
          api_key_name = "OPENAI_API_KEY",
        },
      },
      behaviour = {
        auto_suggestions = true,  -- Enable AI auto suggestions
      },
    },
    build = "make",
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-web-devicons",
      "zbirenbaum/copilot.lua",
      {
        "HakonHarnes/img-clip.nvim",
        event = "VeryLazy",
        opts = {
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = { insert_mode = true },
            use_absolute_path = true,
          },
        },
      },
      {
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },
      "Kaiser-Yang/blink-cmp-avante",
    },
  },
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        default = { 'avante', 'lsp', 'path', 'snippets', 'buffer' },
        providers = {
          avante = {
            module = 'blink-cmp-avante',
            name = 'Avante',
          }
        },
      },
    },
  },
}
