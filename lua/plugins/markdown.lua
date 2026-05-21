return {
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters_by_ft = opts.linters_by_ft or {}
      opts.linters_by_ft.markdown = {}
      opts.linters_by_ft["markdown.mdx"] = {}
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      local formatters_by_ft = opts.formatters_by_ft or {}

      for _, ft in ipairs({ "markdown", "markdown.mdx" }) do
        if formatters_by_ft[ft] then
          formatters_by_ft[ft] = vim.tbl_filter(function(formatter)
            return formatter ~= "markdownlint-cli2"
          end, formatters_by_ft[ft])
        end
      end
    end,
  },
}
