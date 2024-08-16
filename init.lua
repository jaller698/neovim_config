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
update_config()
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
end
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

if vim.g.neovide then
  require "neovide"
end

vim.api.nvim_create_user_command('DiffFormat', function()
  local ignore_filetypes = { "lua" }
  if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
    vim.notify("range formatting for " .. vim.bo.filetype .. " not working properly.")
    return
  end

  local hunks = require("gitsigns").get_hunks()
  if hunks == nil then
    return
  end

  local format = require("conform").format

  local function format_range()
    if next(hunks) == nil then
      vim.notify("done formatting git hunks", "info", { title = "formatting" })
      return
    end
    local hunk = nil
    while next(hunks) ~= nil and (hunk == nil or hunk.type == "delete") do
      hunk = table.remove(hunks)
    end

    if hunk ~= nil and hunk.type ~= "delete" then
      local start = hunk.added.start
      local last = start + hunk.added.count
      -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
      local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
      local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
      format({ range = range, async = true, lsp_fallback = true }, function()
        vim.defer_fn(function()
          format_range()
        end, 1)
      end)
    end
  end

  format_range()
end, { desc = 'Format changed lines' })
