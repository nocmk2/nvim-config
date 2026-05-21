return {
  "marcinjahn/gemini-cli.nvim",
  cmd = "Gemini",
  keys = {
    { "<leader>agg", "<cmd>Gemini toggle<cr>", desc = "Toggle Gemini CLI" },
    { "<leader>aga", "<cmd>Gemini ask<cr>", desc = "Ask Gemini", mode = { "n", "v" } },
    { "<leader>agf", "<cmd>Gemini add_file<cr>", desc = "Add File to Gemini Session" },
    { "<leader>agc", "<cmd>Gemini clear<cr>", desc = "Clear Gemini Session" },
  },
  dependencies = {
    "folke/snacks.nvim",
  },
  opts = {
    -- 你可以在这里添加自定义配置
  },
  config = function(_, opts)
    require("gemini").setup(opts)
  end,
}
