return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
        group_empty_dirs = true,  -- 是否将空目录分组
        filtered_items = {
            visible = true,
            show_hidden_count = true,
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = {
                --'.git', '.DS_Store',  -- 'thumbs.db',
            },
            never_show = {'.git'},
        },
    }
  }
}
