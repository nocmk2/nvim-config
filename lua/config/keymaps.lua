-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
--
--
--
local has_which_key, which_key = pcall(require, "which-key")

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

if has_which_key then
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
      { "<leader>oa", "y:<C-u>split|terminal odpscmdadplus -f <C-r>%|tee ~/odps_temp.sql<cr>", desc = "ODPS ADPlus" },
      { "<leader>oc", "y:<C-u>split|terminal odpscmdcn -f <C-r>%|tee ~/odps_temp.sql<cr>", desc = "ODPS CN" },
      { "<leader>oh", "y:<C-u>split|terminal odpscmdhk -f <C-r>%|tee ~/odps_temp.sql<cr>", desc = "ODPS HK" },
      { "<leader>os", "y:<C-u>split|terminal odpscmdsg -f <C-r>%|tee ~/odps_temp.sql<cr>", desc = "ODPS SG" },
      { "<leader>ot", "y:<C-u>split|terminal odpscmdtap -f <C-r>%|tee ~/odps_temp.sql<cr>", desc = "ODPS Tap" },
    },
  })

  which_key.add({
    {
      mode = "v",
      nowait = true,
      remap = false,
      silent = true,
      { "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', desc = "Comment" },
      { "<leader>sr", "<esc><cmd>'<,'>SnipRun<cr>", desc = "Run range" },
      { "<leader>t", '10yl:r!date -r "<C-r>*" "+\\%Y-\\%m-\\%d\\% \\%H:\\%M:\\%S"<cr>', desc = "Timestamp Convert" },
      { "<leader>m", 'y:r!python3 -c \'from datetime import datetime;print(datetime.strptime("<C-r>*","\\%Y-\\%m-\\%d \\%H:\\%M:\\%S").timestamp()*1000)\'<cr>', desc = "To Milli TimeStamp" },
      { "<leader>o", group = "Odpscmd" },
      { "<leader>oa", function() run_visual_odps("odpscmdadplus") end, desc = "ODPS ADPlus" },
      { "<leader>oc", function() run_visual_odps("odpscmdcn") end, desc = "ODPS CN" },
      { "<leader>oh", function() run_visual_odps("odpscmdhk") end, desc = "ODPS HK" },
      { "<leader>os", function() run_visual_odps("odpscmdsg") end, desc = "ODPS SG" },
      { "<leader>ot", function() run_visual_odps("odpscmdtap") end, desc = "ODPS Tap" },
      { "<leader>eu", group = "url encode/decode" },
      { "<leader>eud", "y:exec('r!tod -s urldecode ') . shellescape(\"<C-r>*\",1)<cr>", desc = "decode" },
      { "<leader>eue", "y:exec('r!tod -s urlencode ') . shellescape('<C-r>*',1)<cr>", desc = "encode" },
      { "<leader>l", group = "odps logview" },
      { "<leader>lv", "y:exec('r!open https://logview.aliyun.com') . shellescape(\"<C-r>*\",1)<cr>", desc = "logview" },
      { "<leader>j", group = "Java Code" },
      { "<leader>jc", "<cmd>lua require('jdtls').extract_constant(true)<cr>", desc = "Extract Constant" },
      { "<leader>jm", "<cmd>lua require('jdtls').extract_method(true)<cr>", desc = "Extract Method" },
      { "<leader>jv", "<cmd>lua require('jdtls').extract_variable(true)<cr>", desc = "Extract Variable" },
    },
  })
end

local function lazyvim_picker_name()
  return _G.LazyVim and LazyVim.pick and LazyVim.pick.picker and LazyVim.pick.picker.name or nil
end

local function call_fzf(command, opts)
  local ok, fzf = pcall(require, "fzf-lua")
  if ok and type(fzf[command]) == "function" then
    fzf[command](opts or {})
    return true
  end
  return false
end

local function call_telescope(command, opts)
  local ok, telescope = pcall(require, "telescope.builtin")
  if ok and type(telescope[command]) == "function" then
    telescope[command](opts or {})
    return true
  end
  return false
end

local function git_blame_line()
  local ok, gitsigns = pcall(require, "gitsigns")
  if ok and type(gitsigns.blame_line) == "function" then
    local success, err = pcall(gitsigns.blame_line, { full = true })
    if success then
      return
    end
    vim.notify("Gitsigns blame_line failed: " .. tostring(err), vim.log.levels.WARN)
  end

  if vim.fn.exists(":Git") == 2 then
    vim.cmd("Git blame")
  else
    vim.notify("Git blame is unavailable: gitsigns and fugitive are not loaded", vim.log.levels.WARN)
  end
end

local function git_file_history()
  local picker = lazyvim_picker_name()
  if picker == "fzf" and call_fzf("git_bcommits") then
    return
  elseif picker == "telescope" and call_telescope("git_bcommits") then
    return
  elseif _G.Snacks and Snacks.picker and type(Snacks.picker.git_log_file) == "function" then
    Snacks.picker.git_log_file()
    return
  end

  if call_fzf("git_bcommits") or call_telescope("git_bcommits") then
    return
  end
  vim.cmd("Git log --follow -- %")
end

local function git_log_cwd()
  local opts = { cwd = vim.uv.cwd() }
  local picker = lazyvim_picker_name()
  if picker == "fzf" and call_fzf("git_commits", opts) then
    return
  elseif picker == "telescope" and call_telescope("git_commits", opts) then
    return
  elseif _G.Snacks and Snacks.picker and type(Snacks.picker.git_log) == "function" then
    Snacks.picker.git_log(opts)
    return
  end

  if call_fzf("git_commits", opts) or call_telescope("git_commits", opts) then
    return
  end
  vim.cmd("Git log")
end

vim.keymap.set("n", "<leader>fa", function()
  require("telescope.builtin").find_files({ no_ignore = true, hidden = true })
end, { desc = "Find All Files" })

vim.keymap.set("n", "<leader>gb", git_blame_line, { desc = "Git Blame Line" })
vim.keymap.set("n", "<leader>gf", git_file_history, { desc = "Git Current File History" })
vim.keymap.set("n", "<leader>gL", git_log_cwd, { desc = "Git Log (cwd)" })

vim.keymap.set("n", "<leader>go", "<cmd>GBrowse<cr>", { desc = "Open in Git Remote" })
vim.keymap.set("v", "<leader>go", ":GBrowse<cr>", { desc = "Open in Git Remote" })

