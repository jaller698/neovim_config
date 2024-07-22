-- Function to update the Neovim configuration repository
local function update_config()
    -- Path to your local git repository
    local repo_path = vim.fn.stdpath "config"  -- Assuming your config repo is the Neovim config directory

    -- Command to pull the latest changes
    local pull_command = { "git", "-C", repo_path, "pull" }

    -- Execute the command
    local result = vim.fn.systemlist(pull_command)

    -- Print the result of the git pull command
    if vim.v.shell_error == 0 then
        print("Configuration updated successfully!")
    else
        print("Failed to update configuration:")
        for _, line in ipairs(result) do
            print(line)
        end
    end
end

-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
require "lazy_setup"
require "polish"
require("conform").setup({
  formatters_by_ft = {
    cpp = {"clang-format"},
  }
})

require('lspconfig').clangd.setup({
  name='clangd',
  cmd = {
    'clangd',
    '--background-index',
    '--log=verbose',
    '--compile-commands-dir=/home/christian/code/compile_commands/dci/',
    '--all-scopes-completion'
  },
})

vim.api.nvim_create_user_command('DiffFormat', function()
  local lines = vim.fn.system('git diff --unified=0'):gmatch('[^\n\r]+')
  local ranges = {}
  for line in lines do
    if line:find('^@@') then
      local line_nums = line:match('%+.- ')
      if line_nums:find(',') then
        local _, _, first, second = line_nums:find('(%d+),(%d+)')
        table.insert(ranges, {
          start = { tonumber(first), 0 },
          ['end'] = { tonumber(first) + tonumber(second), 0 },
        })
      else
        local first = tonumber(line_nums:match('%d+'))
        table.insert(ranges, {
          start = { first, 0 },
          ['end'] = { first + 1, 0 },
        })
      end
    end
  end
  local format = require('conform').format
  for _, range in pairs(ranges) do
    format {
      range = range,
    }
  end
end, { desc = 'Format changed lines' })


