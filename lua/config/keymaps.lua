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

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}
local mappings = {
  k = {
    name = "sql buffer",
    k = {
      "<cmd>r ~/odps_temp.sql<cr>",
      "Open Odps Result File",
    },
    m = {
      function() process_file() end,
      "Open Odps Result File in Markdown",
    }
  },
  i = {
    name = "Insert",
    t = { ":put =strftime('%FT%T%z')|:norm kJ<cr>", "Current Time" },
    -- m = {":put =strftime('%s')|:norm kJ<cr>", "Current TimeStamp"}
    m = { ":r!python3 -c 'import time;print(round(time.time()*1000))'<cr>", "Current TimeStamp" },
  },
  o = {
    name = "Odpscmd",
    -- s = {'<cmd><C-u>split|terminal odpscmd -e "<C-r>0"'},
    -- s = { '<esc><cmd>1split|terminal odpscmdsg -e "<C-r><C-w>"<cr>', "SG" },
    -- s = { '<esc><cmd>split|terminal odpscmdsg -e "<C-r>0"<cr>', "SG" },
    -- s = { 'y:<C-u>split|terminal odpscmdsg -e "<C-r>*"|tee ~/odps_temp.sql<cr>', "新加坡odps"},
    -- t = { 'y:<C-u>split|terminal odpscmdtap -e "<C-r>*"|tee ~/odps_temp.sql<cr>', "taptap北京odps"},
    -- c = { 'y:<C-u>split|terminal odpscmdcn -e "<C-r>*"|tee ~/odps_temp.sql<cr>', "CN北京odps"},
    c = { "y:<C-u>split|terminal odpscmdcn -f <C-r>%|tee ~/odps_temp.sql<cr>", "CN北京odps" },
    s = { "y:<C-u>split|terminal odpscmdsg -f <C-r>%|tee ~/odps_temp.sql<cr>", "新加坡odps" },
    t = { "y:<C-u>split|terminal odpscmdtap -f <C-r>%|tee ~/odps_temp.sql<cr>", "taptap北京odps" },
    h = { "y:<C-u>split|terminal odpscmdhk -f <C-r>%|tee ~/odps_temp.sql<cr>", "taptap香港odps" },
    -- x = { 'y:<C-u>echo <C-r>%<cr>', "新加坡odps"}
  },
  j = {
    name = "Java Code",
    o = { "<cmd>lua require'jdtls'.organize_imports()<cr>", "Organize Imports" },
    v = { "<cmd>lua require('jdtls').extract_variable()<cr>", "Extract Variable" },
    c = { "<cmd>lua require('jdtls').extract_constant()<cr>", "Extract Constant" },
    t = { "<cmd>lua require('jdtls').test_class()<cr>", "Test Class" },
    n = { "<cmd>lua require('jdtls').test_nearest_method()<cr>", "Test Nearest Method" },
  },
}

local vopts = {
  mode = "v", -- VISUAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}
local vmappings = {
  ["/"] = { '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>', "Comment" },
  s = { "<esc><cmd>'<,'>SnipRun<cr>", "Run range" },
  -- date -r 1659320445 "+%Y-%m-%d% %H:%M:%S"
  t = { '10yl:r!date -r "<C-r>*" "+\\%Y-\\%m-\\%d\\% \\%H:\\%M:\\%S"<cr>', "Timestamp Convert" },
  m = {
    'y:r!python3 -c \'from datetime import datetime;print(datetime.strptime("<C-r>*","\\%Y-\\%m-\\%d \\%H:\\%M:\\%S").timestamp()*1000)\'<cr>',
    "To Milli TimeStamp",
  },
  o = {
    name = "Odpscmd",
    s = {
      function()
        -- 生成带时间戳的文件名
        local timestamp = os.date("%Y%m%d%H%M%S")
        local filename = "temp_" .. timestamp .. ".sql"

        -- 确保重新选择
        vim.cmd("normal! gv")

        -- 获取当前视觉选择的行或使用当前行
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")

        -- 将选定的行写入文件
        vim.cmd(string.format("silent! execute '%d, %dw! %s'", start_line, end_line, filename))

        -- 打开一个分屏终端并运行命令
        local terminal_command =
          string.format("split | terminal cat %s && odpscmdsg -f %s | tee ~/odps_temp.sql", filename, filename)
        vim.cmd(terminal_command)
      end,
      "新加坡odps", -- 命令描述
    },
    t = {
      function()
        -- 生成带时间戳的文件名
        local timestamp = os.date("%Y%m%d%H%M%S")
        local filename = "temp_" .. timestamp .. ".sql"

        -- 确保重新选择
        vim.cmd("normal! gv")

        -- 获取当前视觉选择的行或使用当前行
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")

        -- 将选定的行写入文件
        vim.cmd(string.format("silent! execute '%d, %dw! %s'", start_line, end_line, filename))

        -- 打开一个分屏终端并运行命令
        local terminal_command =
          string.format("split | terminal cat %s && odpscmdtap -f %s | tee ~/odps_temp.sql", filename, filename)
        vim.cmd(terminal_command)
      end,
      "taptap北京odps", -- 命令描述
    },
    c = {
      function()
        -- 生成带时间戳的文件名
        local timestamp = os.date("%Y%m%d%H%M%S")
        local filename = "temp_" .. timestamp .. ".sql"

        -- 确保重新选择
        vim.cmd("normal! gv")

        -- 获取当前视觉选择的行或使用当前行
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")

        -- 将选定的行写入文件
        vim.cmd(string.format("silent! execute '%d, %dw! %s'", start_line, end_line, filename))

        -- 打开一个分屏终端并运行命令
        local terminal_command =
          string.format("split | terminal cat %s && odpscmdcn -f %s | tee ~/odps_temp.sql", filename, filename)
        vim.cmd(terminal_command)
      end,
      "CN北京odps", -- 命令描述
    },
    h = {
      function()
        -- 生成带时间戳的文件名
        local timestamp = os.date("%Y%m%d%H%M%S")
        local filename = "temp_" .. timestamp .. ".sql"

        -- 确保重新选择
        vim.cmd("normal! gv")

        -- 获取当前视觉选择的行或使用当前行
        local start_line = vim.fn.line("'<")
        local end_line = vim.fn.line("'>")


        -- 将选定的行写入文件
        vim.cmd(string.format("silent! execute '%d, %dw! %s'", start_line, end_line, filename))

        -- 打开一个分屏终端并运行命令
        local terminal_command =
          string.format("split | terminal cat %s && odpscmdhk -f %s | tee ~/odps_temp.sql", filename, filename)
        vim.cmd(terminal_command)
      end,
      "香港odps", -- 命令描述
    },
  },
  u = {
    name = "url encode/decode",
    -- d = {"y:r!node -e 'console.log(decodeURIComponent(escape(\"<C-r>*\".replace(\'%\',\'\\*\'))))'<cr>", "decode"},
    -- d = {"y:exec 'r!python3 -c 'import urllib.parse as u;print(u.unquote(\"\"\"<C-r>*\"\"\"))'<cr>", "decode"},
    -- d = {"y:r!python3 -c 'import urllib.parse as u;print(u.unquote(\"\"\"<C-r>*\"\"\".replace(\"\\%\",\"\\\\%\")))'<cr>", "decode"},
    d = { "y:exec('r!tod -s urldecode ') . shellescape(\"<C-r>*\",1)<cr>", "decode" },
    e = { "y:exec('r!tod -s urlencode ') . shellescape('<C-r>*',1)<cr>", "encode" },
    -- d = {"<cmd>UrlEncode<cr>"}
    -- e = { "y:r!python3 -c 'import urllib.parse as u;print(u.quote(\"\"\"<C-r>*\"\"\".replace(\"\\%\",\"\\\\%\")))'<cr>",
    --   "encode" },
  },
  l = {
    name = "odps logview",
    -- d = {"y:r!node -e 'console.log(decodeURIComponent(escape(\"<C-r>*\".replace(\'%\',\'\\*\'))))'<cr>", "decode"},
    -- d = {"y:exec 'r!python3 -c 'import urllib.parse as u;print(u.unquote(\"\"\"<C-r>*\"\"\"))'<cr>", "decode"},
    -- d = {"y:r!python3 -c 'import urllib.parse as u;print(u.unquote(\"\"\"<C-r>*\"\"\".replace(\"\\%\",\"\\\\%\")))'<cr>", "decode"},
    v = { "y:exec('r!open https://logview.aliyun.com') . shellescape(\"<C-r>*\",1)<cr>", "logview" },
  },
  j = {
    name = "Java Code",
    v = { "<cmd>lua require('jdtls').extract_variable(true)<cr>", "Extract Variable" },
    c = { "<cmd>lua require('jdtls').extract_constant(true)<cr>", "Extract Constant" },
    m = { "<cmd>lua require('jdtls').extract_method(true)<cr>", "Extract Method" },
  },
}

which_key.register(mappings, opts)
which_key.register(vmappings, vopts)


