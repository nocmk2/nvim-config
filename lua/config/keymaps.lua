-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
--
--
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

local function process_file()
  local input_file = os.getenv("HOME") .. "/odps_temp.sql"
  local output_file = os.getenv("HOME") .. "/odps_temp.md"

  -- Read the file content
  local lines = {}
  for line in io.lines(input_file) do
    table.insert(lines, line)
  end

  -- Remove the first and last lines
  table.remove(lines, 1) -- Remove the first line
  table.remove(lines) -- Remove the last line

  -- Replace '+' with '|'
  for i, line in ipairs(lines) do
    lines[i] = line:gsub("%+", "|")
  end

  -- Write to the new .md file
  local file = io.open(output_file, "w")
  for _, line in ipairs(lines) do
    file:write(line .. "\n")
  end
  file:close()

  -- Open the new file in a vertical split
  vim.cmd("vsplit " .. output_file)
end

local function run_visual_odps(command)
  local timestamp = os.date("%Y%m%d%H%M%S")
  local filename = "temp_" .. timestamp .. ".sql"
  vim.cmd("normal! gv")
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  vim.cmd(string.format("silent! execute '%d, %dw! %s'", start_line, end_line, filename))
  local terminal_command = string.format("split | terminal cat %s && %s -f %s | tee ~/odps_temp.sql", filename, command, filename)
  vim.cmd(terminal_command)
end

which_key.add({
  {
    mode = "n",
    nowait = true,
    remap = false,
    silent = true,
    { "<leader>i", group = "Insert" },
    { "<leader>im", ":r!python3 -c 'import time;print(round(time.time()*1000))'<cr>", desc = "Current TimeStamp" },
    { "<leader>it", ":put =strftime('%FT%T%z')|:norm kJ<cr>", desc = "Current Time" },
    { "<leader>j", group = "Java Code" },
    { "<leader>jc", "<cmd>lua require('jdtls').extract_constant()<cr>", desc = "Extract Constant" },
    { "<leader>jn", "<cmd>lua require('jdtls').test_nearest_method()<cr>", desc = "Test Nearest Method" },
    { "<leader>jo", "<cmd>lua require'jdtls'.organize_imports()<cr>", desc = "Organize Imports" },
    { "<leader>jt", "<cmd>lua require('jdtls').test_class()<cr>", desc = "Test Class" },
    { "<leader>jv", "<cmd>lua require('jdtls').extract_variable()<cr>", desc = "Extract Variable" },
    { "<leader>k", group = "sql buffer" },
    { "<leader>kk", "<cmd>r ~/odps_temp.sql<cr>", desc = "Open Odps Result File" },
    { "<leader>km", process_file, desc = "Open Odps Result File in Markdown" },
    { "<leader>o", group = "Odpscmd" },
    { "<leader>oa", "y:<C-u>split|terminal odpscmdadplus -f <C-r>%|tee ~/odps_temp.sql<cr>", desc = "adplus北京" },
    { "<leader>oc", "y:<C-u>split|terminal odpscmdcn -f <C-r>%|tee ~/odps_temp.sql<cr>", desc = "CN北京odps" },
    { "<leader>oh", "y:<C-u>split|terminal odpscmdhk -f <C-r>%|tee ~/odps_temp.sql<cr>", desc = "taptap香港odps" },
    { "<leader>os", "y:<C-u>split|terminal odpscmdsg -f <C-r>%|tee ~/odps_temp.sql<cr>", desc = "新加坡odps" },
    { "<leader>ot", "y:<C-u>split|terminal odpscmdtap -f <C-r>%|tee ~/odps_temp.sql<cr>", desc = "taptap北京odps" },
  },
})

vim.keymap.set("n", "<leader>fa", function()
  require("telescope.builtin").find_files({ no_ignore = true, hidden = true })
end, { desc = "Find All Files" })

