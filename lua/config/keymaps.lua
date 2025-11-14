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
    table.remove(lines, 1)  -- Remove the first line
    table.remove(lines)      -- Remove the last line

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

-- Using the new which-key format for normal mode
which_key.register({
  mode = "n",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
  i = {
    name = "Insert",
    t = { ":put =strftime('%FT%T%z')|:norm kJ<cr>", "Current Time" },
    m = { ":r!python3 -c 'import time;print(round(time.time()*1000))'<cr>", "Current TimeStamp" },
  },
  j = {
    name = "Java Code",
    o = { "<cmd>lua require'jdtls'.organize_imports()<cr>", "Organize Imports" },
    v = { "<cmd>lua require('jdtls').extract_variable()<cr>", "Extract Variable" },
    c = { "<cmd>lua require('jdtls').extract_constant()<cr>", "Extract Constant" },
    t = { "<cmd>lua require('jdtls').test_class()<cr>", "Test Class" },
    n = { "<cmd>lua require('jdtls').test_nearest_method()<cr>", "Test Nearest Method" },
  },
  k = {
    name = "sql buffer",
    k = { "<cmd>r ~/odps_temp.sql<cr>", "Open Odps Result File" },
    m = { process_file, "Open Odps Result File in Markdown" },
  },
  o = {
    name = "Odpscmd",
    c = { "y:<C-u>split|terminal odpscmdcn -f <C-r>%|tee ~/odps_temp.sql<cr>", "CN北京odps" },
    s = { "y:<C-u>split|terminal odpscmdsg -f <C-r>%|tee ~/odps_temp.sql<cr>", "新加坡odps" },
    t = { "y:<C-u>split|terminal odpscmdtap -f <C-r>%|tee ~/odps_temp.sql<cr>", "taptap北京odps" },
    h = { "y:<C-u>split|terminal odpscmdhk -f <C-r>%|tee ~/odps_temp.sql<cr>", "taptap香港odps" },
    a = { "y:<C-u>split|terminal odpscmdadplus -f <C-r>%|tee ~/odps_temp.sql<cr>", "adplus北京" }
  },
})

-- Using the new which-key format for visual mode
which_key.register({
  mode = "v",
  prefix = "<leader>",
  buffer = nil,
  silent = true,
  noremap = true,
  nowait = true,
  ["/"] = { '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', "Comment" },
  sr = { "<esc><cmd>'<,'>SnipRun<cr>", "Run range" },
  t = { '10yl:r!date -r "<C-r>*" "+\\%Y-\\%m-\\%d\\% \\%H:\\%M:\\%S"<cr>', "Timestamp Convert" },
  m = { 'y:r!python3 -c \'from datetime import datetime;print(datetime.strptime("<C-r>*","\\%Y-\\%m-\\%d \\%H:\\%M:\\%S").timestamp()*1000)\'<cr>', "To Milli TimeStamp" },
  o = {
    name = "Odpscmd",
    s = {
      function()
        local timestamp = os.date("%Y%m%d%H%M%S")
        local filename = "temp_" .. timestamp .. ".sql"
        vim.cmd("normal! gv")
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")
        vim.cmd(string.format("silent! execute '%d, %dw! %s'", start_line, end_line, filename))
        local terminal_command = string.format("split | terminal cat %s && odpscmdsg -f %s | tee ~/odps_temp.sql", filename, filename)
        vim.cmd(terminal_command)
      end,
      "新加坡odps",
    },
    t = {
      function()
        local timestamp = os.date("%Y%m%d%H%M%S")
        local filename = "temp_" .. timestamp .. ".sql"
        vim.cmd("normal! gv")
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")
        vim.cmd(string.format("silent! execute '%d, %dw! %s'", start_line, end_line, filename))
        local terminal_command = string.format("split | terminal cat %s && odpscmdtap -f %s | tee ~/odps_temp.sql", filename, filename)
        vim.cmd(terminal_command)
      end,
      "taptap北京odps",
    },
    c = {
      function()
        local timestamp = os.date("%Y%m%d%H%M%S")
        local filename = "temp_" .. timestamp .. ".sql"
        vim.cmd("normal! gv")
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")
        vim.cmd(string.format("silent! execute '%d, %dw! %s'", start_line, end_line, filename))
        local terminal_command = string.format("split | terminal cat %s && odpscmdcn -f %s | tee ~/odps_temp.sql", filename, filename)
        vim.cmd(terminal_command)
      end,
      "CN北京odps",
    },
    h = {
      function()
        local timestamp = os.date("%Y%m%d%H%M%S")
        local filename = "temp_" .. timestamp .. ".sql"
        vim.cmd("normal! gv")
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")
        vim.cmd(string.format("silent! execute '%d, %dw! %s'", start_line, end_line, filename))
        local terminal_command = string.format("split | terminal cat %s && odpscmdhk -f %s | tee ~/odps_temp.sql", filename, filename)
        vim.cmd(terminal_command)
      end,
      "香港odps",
    },
    a = {
      function()
        local timestamp = os.date("%Y%m%d%H%M%S")
        local filename = "temp_" .. timestamp .. ".sql"
        vim.cmd("normal! gv")
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")
        vim.cmd(string.format("silent! execute '%d, %dw! %s'", start_line, end_line, filename))
        local terminal_command = string.format("split | terminal cat %s && odpscmdadplus -f %s | tee ~/odps_temp.sql", filename, filename)
        vim.cmd(terminal_command)
      end,
      "adplus北京",
    },
  },
  eu = {
    name = "url encode/decode",
    d = { "y:exec('r!tod -s urldecode ') . shellescape(\"<C-r>*\",1)<cr>", "decode" },
    e = { "y:exec('r!tod -s urlencode ') . shellescape('<C-r>*',1)<cr>", "encode" },
  },
  l = {
    name = "odps logview",
    v = { "y:exec('r!open https://logview.aliyun.com') . shellescape(\"<C-r>*\",1)<cr>", "logview" },
  },
  j = {
    name = "Java Code",
    v = { "<cmd>lua require('jdtls').extract_variable(true)<cr>", "Extract Variable" },
    c = { "<cmd>lua require('jdtls').extract_constant(true)<cr>", "Extract Constant" },
    m = { "<cmd>lua require('jdtls').extract_method(true)<cr>", "Extract Method" },
  },
})


