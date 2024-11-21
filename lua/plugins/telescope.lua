return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({ no_ignore = true, hidden = true })
        end,
        desc = "Find Files",
      },
    },
    opts = {
      defaults = {
        path_display = { "smart" },
        prompt_prefix = "🔍 ", -- Customize the prompt prefix
        selection_caret = "➜ ", -- Customize the selection caret
        entry_prefix = "  ", -- Customize the entry prefix
        initial_mode = "insert", -- Start in insert mode
        layout_strategy = "horizontal", -- Use horizontal layout
        layout_config = {
          horizontal = {
            mirror = false, -- Prevent mirroring
            preview_width = 0.4, -- Adjust preview width
          },
          vertical = {
            mirror = false, -- Prevent mirroring
          },
        },
        sorting_strategy = "descending",
        winblend = 0,
        -- Use ripgrep for searching
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "-u", -- Enable Unicode support
        },

        -- Customizing the layout border
        border = true,
        borderchars = {
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ",
          " ", -- More decorative border characters
        },
      },
    },
  },
}
